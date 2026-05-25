/*
==============================
Silver erp_loc_a101 Loading 
==============================
This script cleans the bronze.erp_loc_a101 table and loads it into silver.erp_loc_a101
*/
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
