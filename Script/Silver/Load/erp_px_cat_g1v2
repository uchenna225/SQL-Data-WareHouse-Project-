/*
==============================
Silver erp_px_cat_g1v2 Loading 
==============================
This script cleans the bronze.erp_px_cat_g1v2 table and loads it into silver.erp_px_cat_g1v2
*/
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
