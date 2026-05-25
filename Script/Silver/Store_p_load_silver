/* 
==========================
Silver Load 
==========================

Purpose:
This script truncates the silver tables and loads cleaned and transformed data from the bronze layer
It calculates the time it takes to load each table
Data transformation and cleaning is done at this level

Warning: All previous data in silver tables will be lost

Usage Example: EXEC silver.load_silver

*/

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	-- declares variables for load time tracking
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY

		SET @batch_start_time = GETDATE();

		PRINT '====================================='
		PRINT 'Loading Silver'
		PRINT '====================================='

		PRINT ' '
		PRINT 'Loading silver.crm'
		PRINT '--------------------------'

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.crm_customer_info'
			TRUNCATE TABLE silver.crm_customer_info

			PRINT 'LOADING: silver.crm_customer_info'
			INSERT INTO silver.crm_customer_info(
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
				)
			SELECT 
				cst_id,
				cst_key,
				TRIM(cst_firstname) AS cst_firstname,
				TRIM(cst_lastname) AS cst_lastname,
				-- maps marital status codes to full descriptive names
				CASE 
					WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
					WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
					ELSE 'N/A'
				END AS cst_marital_status,
				-- maps gender codes to full descriptive names
				CASE 
					WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
					WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
					ELSE 'N/A'
				END AS cst_gndr,
				cst_create_date
			FROM(
				-- deduplicates by customer ID, keeping the most recent record by creation date
				SELECT *,
					ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS dup_check
				FROM bronze.crm_customer_info
				WHERE cst_id IS NOT NULL
			)WORK
			WHERE dup_check = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

			PRINT ' '

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.crm_prd_info'
			TRUNCATE TABLE silver.crm_prd_info

			PRINT 'LOADING: silver.crm_prd_info'
			INSERT INTO silver.crm_prd_info(
				prd_id,
				prd_cat,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
				)
			SELECT 
				prd_id,
				-- extracts the first 5 chars of prd_key and replaces dashes with underscores to derive the category
				REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS prd_cat,
				-- extracts the product key portion, skipping the category prefix
				SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
				-- trims leading and trailing whitespace from the product name
				TRIM(prd_nm) AS prd_nm,
				-- defaults null costs to 0
				ISNULL(prd_cost, 0) AS prd_cost,
				-- maps single-letter product line codes to full descriptive names
				CASE 
					WHEN TRIM(UPPER(prd_line)) = 'R' THEN 'Road'
					WHEN TRIM(UPPER(prd_line)) = 'S' THEN 'Other Sales'
					WHEN TRIM(UPPER(prd_line)) = 'M' THEN 'Mountain'
					WHEN TRIM(UPPER(prd_line)) = 'T' THEN 'Touring'
					ELSE 'N/A'  
				END AS prd_line,
				CAST(prd_start_dt AS DATE) AS prd_start_dt,
				-- derives end date as one day before the next record's start date within the same product key, preventing overlapping date ranges
				CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt
			FROM(
				-- deduplicates records by assigning a row number per prd_id, ordered by prd_key
				SELECT 
					*,
					ROW_NUMBER() OVER(PARTITION BY prd_id ORDER BY prd_key) AS DUPCHECK
				FROM bronze.crm_production_info
				)DUPS
			-- filters out duplicate records, keeping only the first occurrence per prd_id
			WHERE DUPCHECK = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

			PRINT ' '

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.crm_sales_details'
			TRUNCATE TABLE silver.crm_sales_details

			PRINT 'LOADING: silver.crm_sales_details'
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
						ROW_NUMBER() OVER(PARTITION BY sls_ord_num, sls_prd_key ORDER BY sls_order_dt) AS dupcheck
					FROM bronze.crm_sales_details
				)dups
			-- filters out duplicates, keeping only the first occurrence
			WHERE dupcheck = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT ' '
		PRINT 'Loading silver.erp'
		PRINT '--------------------------'
		PRINT ' '

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.erp_cust_az12'
			TRUNCATE TABLE silver.erp_cust_az12

			PRINT 'LOADING: silver.erp_cust_az12'
			INSERT INTO silver.erp_cust_az12(
				cid,
				Bdate,
				gen
				)
			SELECT 
				-- removes 'NAS' prefix from customer ID if present to standardize the format
				CASE 
					WHEN cid LIKE 'NAS%' 
					THEN SUBSTRING(cid, 4, LEN(cid))
					ELSE cid
				END AS cid,
				-- nulls out future birth dates as they are invalid
				CASE 
					WHEN Bdate > GETDATE() 
					THEN NULL
					ELSE Bdate
				END AS Bdate,
				-- maps various gender representations to a standard Male/Female/N/A format
				CASE 
					WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
					WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
					ELSE 'N/A'
				END AS gen
			FROM (
					-- deduplicates by customer ID, keeping the record with the earliest birth date
					SELECT 
						*,
						ROW_NUMBER() OVER(PARTITION BY cid ORDER BY Bdate) AS dupcheck
					FROM bronze.erp_cust_az12
				)DUPS
			-- filters out duplicates, keeping only the first occurrence per customer
			WHERE dupcheck = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

			PRINT ' '

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.erp_loc_a101'
			TRUNCATE TABLE silver.erp_loc_a101

			PRINT 'LOADING: silver.erp_loc_a101'
			INSERT INTO silver.erp_loc_a101(
				cid,
				CNTRY
				)
			SELECT 
				-- removes dashes from customer ID and trims whitespace to standardize the format
				TRIM(REPLACE(cid, '-', '')) AS cid,
				-- maps country codes and abbreviations to full country names, handles empty/null as N/A
				CASE 
					WHEN TRIM(UPPER(CNTRY)) IN ('USA', 'US') THEN 'United States'
					WHEN TRIM(UPPER(CNTRY)) = 'DE' THEN 'Germany'
					WHEN TRIM(UPPER(CNTRY)) = '' OR CNTRY IS NULL THEN 'N/A'
					ELSE TRIM(CNTRY)
				END AS CNTRY
			FROM (
					-- deduplicates by customer ID, keeping the first record ordered by country
					SELECT 
						*,
						ROW_NUMBER() OVER(PARTITION BY cid ORDER BY CNTRY) AS dupcheck
					FROM bronze.erp_loc_a101
				)DUPS
			-- filters out duplicates, keeping only the first occurrence per customer
			WHERE dupcheck = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

			PRINT ' '

			SET @start_time = GETDATE();
			PRINT 'TRUNCATING TABLE: silver.erp_px_cat_g1v2'
			TRUNCATE TABLE silver.erp_px_cat_g1v2

			PRINT 'LOADING: silver.erp_px_cat_g1v2'
			INSERT INTO silver.erp_px_cat_g1v2(
				ID,
				CAT,
				SUBCAT,
				MAINTENANCE
				)
			SELECT 
				-- trims whitespace from all columns to standardize the format
				TRIM(ID) AS ID,
				TRIM(CAT) AS CAT,
				TRIM(SUBCAT) AS SUBCAT,
				TRIM(MAINTENANCE) AS MAINTENANCE
			FROM (
					-- deduplicates by ID, keeping the first record ordered by category and subcategory
					SELECT 
						*,
						ROW_NUMBER() OVER (PARTITION BY ID ORDER BY CAT, SUBCAT) AS DUPCHECK
					FROM bronze.erp_px_cat_g1v2
				)DUPS
			-- filters out duplicates, keeping only the first occurrence per ID
			WHERE DUPCHECK = 1
			SET @end_time = GETDATE();
			PRINT '>>>>>>>>> ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'ERROR STATE: '  + CAST(ERROR_STATE() AS NVARCHAR)
	END CATCH

	PRINT ' '
	SET @batch_end_time = GETDATE();
	PRINT '>>>>>>>>> ' + 'Total load time is' + ' ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

END
