/*
==============================
Silver crm_sales_details Loading 
==============================
This script cleans the bronze.crm_sales_details table and loads it into silver.crm_sales_details
*/
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
SELECT 
	-- trims whitespace from order number and product key
	TRIM(sls_ord_num) AS sls_ord_num,
	TRIM(sls_prd_key) AS sls_prd_key,
	sls_cust_id,
	-- validates order date: nulls out invalid dates (0 or not 8 digits) before casting to DATE
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	-- safely converts ship and due dates, returning NULL if conversion fails
	TRY_CAST(sls_ship_dt AS DATE) AS sls_ship_dt,
	TRY_CAST(sls_due_dt AS DATE) AS sls_due_dt,
	-- recalculates sales if null, zero, negative, or inconsistent with quantity * price
	CASE 
		WHEN sls_sales != ABS(sls_quantity) * ABS(sls_price)
		OR sls_sales <= 0
		OR sls_sales IS NULL
		THEN ABS(sls_quantity) * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	-- ensures quantity is always a positive number
	ABS(sls_quantity) AS sls_quantity,
	-- recalculates price if null, zero, negative, or inconsistent with sales / quantity
	-- NULLIF prevents division by zero by returning NULL when quantity is 0
	CASE 
		WHEN sls_price != ABS(sls_sales) / NULLIF(ABS(sls_quantity), 0)
		OR sls_price <= 0
		OR sls_price IS NULL
		THEN ABS(sls_sales) / NULLIF(ABS(sls_quantity), 0)
		ELSE sls_price
	END AS sls_price
FROM (
		-- deduplicates by order number and product key, keeping the earliest order date per combination
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY sls_ord_num, sls_prd_key ORDER BY sls_order_dt) dupcheck
		FROM bronze.crm_sales_details
	)dups
-- filters out duplicates, keeping only the first occurrence
WHERE dupcheck = 1
