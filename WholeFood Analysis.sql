USE bos_ddmban_sql_analysis;

SELECT *
FROM bmbandd_data;

-- query that the represents the sum of badges per category

SELECT category, sum(CASE 
		WHEN is_vegan = 1 THEN 1
        WHEN is_keto_friendly = 1 THEN 1
        WHEN is_paleo_friendly = 1 then 1
        WHEN is_gluten_free = 1 then 1
        when is_vegetarian = 1 then 1
        when is_kosher = 1 then 1
        when is_sugar_conscious = 1 then 1
        when is_dairy_free = 1 then 1
        when is_high_fiber = 1 then 1
        when is_engine_2 = 1 then 1
        when is_low_sodium = 1 then 1
        when is_low_fat = 1 then 1
        when is_wheat_free = 1 then 1
        when is_organic = 1 then 1
        when is_whole_foods_diet = 1 then 1 else 0
        END) AS total_num_badges
FROM bmbandd_data
GROUP BY category;

-- subquery of average price of products with badge
SELECT category, ROUND(AVG(regular_price),2) AS price_w_badge
FROM bmbandd_data
WHERE sum_badges >=1
GROUP BY category
;

-- subquery of average price of products without badge
SELECT 
		category, 
        ROUND(AVG(regular_price),2) AS price_wo_badge
FROM bmbandd_data
WHERE sum_badges = 0
GROUP BY category
;


/*
With this query is possible to see the number of products with badge per category. 
*/

SELECT 
		category, 
        ROUND(AVG(regular_price),2) AS price_w_badge,
        COUNT(wf_product_id) AS number_of_product_with_badge
FROM bmbandd_data
WHERE sum_badges >=1
GROUP BY category
;

/* 
With this query is possible to see the number of products without badge per category. It means that Whole Foods can increase the amount of badges
in the categories since the difference in the amount of products that have badges is higher.
*/
SELECT 
		category, 
        ROUND(AVG(regular_price),2) AS price_wo_badge,
        COUNT(wf_product_id) AS number_of_product_without_badge
FROM bmbandd_data
WHERE sum_badges = 0
GROUP BY category
;

/* 
This query was made to show the difference in the price of products with badge and the products without badge for each category.
Thus, in oder to see if the number of badges increase the price of the products.
*/

SELECT 
	sub_1.category,
    price_w_badge,
    price_wo_badge,
    ROUND((price_w_badge - price_wo_badge),2) AS delta,
    CASE 
		WHEN price_w_badge > price_wo_badge THEN "Independent" ELSE "Dependent"
	END AS indicator
FROM
		(SELECT 
				category, 
				ROUND(AVG(regular_price),2) AS price_w_badge
		FROM bmbandd_data
				WHERE sum_badges >=1
				GROUP BY category) AS sub_1
LEFT JOIN (SELECT 
			category, 
			ROUND(AVG(regular_price),2) AS price_wo_badge
		 FROM bmbandd_data
		 WHERE sum_badges = 0
		 GROUP BY category) AS sub_2
ON sub_1.category = sub_2.category
WHERE price_wo_badge IS NOT NULL
;

/* 
Hypothesis table per category. Including the avg price per category and the standard deviation of each category 
*/

SELECT 
		category, 
		round(AVG(regular_price),2) AS avg_regular_price_per_category,
        COUNT(wf_product_id) AS product_per_category,
		ROUND(stddev_samp(regular_price),2) AS standard_dev
FROM bmbandd_data
GROUP BY category
;

-- hypothesis table for sum_badges >= 1 with the standrad deviation to analize in excel
SELECT 
		category, 
		round(AVG(regular_price),2) AS avg_regular_price_per_category_w_badge,
        COUNT(wf_product_id) AS product_per_category,
		ROUND(stddev_samp(regular_price),2) AS standard_dev
FROM bmbandd_data
WHERE sum_badges >= 1
GROUP BY category
;
