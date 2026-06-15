/*
==============================
Gold dim_products View
==============================
This view builds the product dimension by joining the CRM product info
with ERP product category data from the silver layer.
Only current products are included by filtering out records with an end date
*/
CREATE OR ALTER VIEW gold.dim_products AS 
	SELECT 
		-- generates a surrogate key for the dimension table, ordered by product and start date
		ROW_NUMBER() OVER(ORDER BY pm.prd_key, pm.prd_start_dt) AS product_key,
		pm.prd_id AS product_id,	
		pm.prd_key AS product_number,
		pm.prd_nm AS product_name,
		pm.prd_cat AS category_id,
		px.CAT AS category,
		px.SUBCAT AS subcategory,
		px.MAINTENANCE AS maintenance,
		pm.prd_cost AS cost,
		pm.prd_line AS product_line,
		pm.prd_start_dt AS start_date
	FROM silver.crm_prd_info pm
	-- joins ERP category data to enrich with full category, subcategory and maintenance info
	LEFT JOIN silver.erp_px_cat_g1v2 px
		ON pm.prd_cat = px.ID
	-- filters to only current products, excluding historical records that have been superseded
	WHERE pm.prd_end_dt IS NULL
