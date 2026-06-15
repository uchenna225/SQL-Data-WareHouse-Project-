/* 
==========================
Gold Layer Views
==========================

Purpose:
This script creates the gold layer views which represent the final
data model for analytics and reporting.
It joins and integrates cleaned silver layer data into a star schema
consisting of dimension and fact views.

Warning: These are views, not tables. They do not store data —
they query the silver layer in real time when accessed.
Recreating these views will replace any existing definitions.

Usage Example: 
SELECT * FROM gold.dim_customers
SELECT * FROM gold.dim_products
SELECT * FROM gold.facts_sales

*/


/*
==============================
Gold dim_customers View
==============================
This view builds the customer dimension by joining the CRM customer info
with ERP customer and location data from the silver layer
*/
CREATE OR ALTER VIEW gold.dim_customers AS
	SELECT 
		-- generates a surrogate key for the dimension table
		ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		-- resolves gender conflict between CRM and ERP: CRM is the master source,
		-- ERP gender is only used as a fallback when CRM has no valid value
		CASE 
			WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
			ELSE COALESCE(ca.gen, 'N/A')
		END AS gender,
		ca.Bdate AS birthdate,
		ci.cst_marital_status AS marital_status,
		ea.CNTRY AS country,
		ci.cst_create_date AS create_date
	FROM silver.crm_customer_info ci
	-- joins ERP customer data to enrich with birthdate and gender
	LEFT JOIN silver.erp_cust_az12 ca
		ON ci.cst_key = ca.cid
	-- joins ERP location data to enrich with country
	LEFT JOIN silver.erp_loc_a101 ea
		ON ci.cst_key = ea.CID


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


/*
==============================
Gold facts_sales View
==============================
This view builds the sales fact table by joining the CRM sales details
with the product and customer dimension views from the gold layer
*/
CREATE OR ALTER VIEW gold.facts_sales AS
	SELECT 
		sd.sls_ord_num AS order_number,
		-- foreign keys linking to dimension tables
		pr.product_key,
		cu.customer_key,
		sd.sls_order_dt AS order_date,
		sd.sls_ship_dt AS shipping_date,
		sd.sls_due_dt AS due_date,
		-- measures
		sd.sls_sales AS sales_amount,
		sd.sls_quantity AS quantity,
		sd.sls_price AS price 
	FROM silver.crm_sales_details sd
	-- joins to product dimension to resolve product surrogate key
	LEFT JOIN gold.dim_products pr
		ON sd.sls_prd_key = pr.product_number
	-- joins to customer dimension to resolve customer surrogate key
	LEFT JOIN gold.dim_customers cu
		ON sd.sls_cust_id = cu.customer_id
