/*
==============================
Silver crm_prd_info Loading 
==============================
This script cleans the bronze.crm_production_info table and loads it into silver.crm_prd_info 
*/
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
