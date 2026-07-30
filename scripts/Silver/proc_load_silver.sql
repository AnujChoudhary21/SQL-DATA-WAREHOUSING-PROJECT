/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.crm_cust_info
        SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE Silver.crm_cust_info
PRINT '>> Inserting Data Into: silver.crm_cust_info';
INSERT INTO Silver.crm_cust_info(
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date)

SELECT cst_id,
       cst_key,
       TRIM(cst_firstname) as cst_firstname,
       TRIM(cst_lastname) as cst_lastname,
       CASE WHEN UPPER(TRIM(cst_marita_status)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_marita_status)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_marita_status)) = 'S' THEN 'Single'
       ELSE 'n/a'
       END as cst_marita_status,-- Normalize marital status values to readable format
       CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
       ELSE 'n/a'
       END as cst_gndr,-- Normalize gender values to readable format
       cst_create_date
FROM (
SELECT * ,
       ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cst_info
WHERE cst_id IS NOT NULL)t
WHERE flag_last=1-- Select the most recent record per customer

SELECT COUNT(*) FROM Silver.crm_cust_info

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


		-- Loading silver.crm_prd_info
        SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE Silver.crm_prd_info
PRINT '>> Inserting Data Into: silver.crm_prd_info';
INSERT INTO Silver.crm_prd_info(
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt)

SELECT 
      prd_id,
      REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
      SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
      prd_nm,
      ISNULL(prd_cost,0) as prd_cost,
      CASE WHEN UPPER(TRIM (prd_line))= 'R' THEN 'Road'
           WHEN UPPER(TRIM (prd_line))= 'S' THEN 'Other sales'
           WHEN UPPER(TRIM (prd_line))= 'M' THEN 'Mountain'
           WHEN UPPER(TRIM (prd_line))= 'T' THEN 'Touring'
      ELSE 'n/a'
      END as prd_line,
      CAST(prd_start_dt as DATE) as prd_start_dt,
      CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 as DATE) as  prd_end_dt
FROM Bronze.crm_prd_info

SELECT COUNT(*) FROM Silver.crm_prd_info
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


        -- Loading crm_sales_details
        SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_sales_details';
TRUNCATE TABLE Silver.crm_sales_details
PRINT '>> Inserting Data Into: silver.crm_sales_details';
INSERT INTO Silver.crm_sales_details (
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price)

SELECT
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      CASE WHEN sls_order_dt = 0 or LEN(sls_order_dt) != 8 THEN NULL 
      ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
      END sls_order_dt,
      CASE WHEN sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 THEN NULL 
      ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
      END sls_ship_dt,
      CASE WHEN sls_due_dt = 0 or LEN(sls_due_dt) != 8 THEN NULL 
      ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
      END sls_due_dt,
      CASE WHEN sls_sales <= 0 or sls_sales IS NULL or sls_sales != sls_quantity * ABS(sls_price)
      THEN sls_quantity * ABS(sls_price)
      ELSE sls_sales
      END sls_sales,
      sls_quantity,
      CASE WHEN sls_price <= 0 or sls_price IS NULL or sls_price != sls_sales / sls_quantity
      THEN sls_sales / NULLIF(sls_quantity,0)
      ELSE sls_price
      END sls_price
FROM Bronze.crm_sales_details

SELECT COUNT(*) FROM Bronze.crm_sales_details

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading erp_cust_az12
        SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_cust_az12';
TRUNCATE TABLE Silver.erp_cust_az12
PRINT '>> Inserting Data Into: silver.erp_cust_az12';
INSERT INTO Silver.erp_cust_az12 (
     Cid,
     bdate,
     gen)

SELECT
      CASE WHEN Cid like 'NAS%' THEN SUBSTRING( Cid, 4 , LEN (Cid))
      ELSE Cid
      END Cid,
      CASE WHEN bdate> GETDATE() THEN NULL
      ELSE bdate
      END as bdate,
      CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female' 
           WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
      ELSE 'n/a'
      END as gen
FROM Bronze.erp_cust_az12

SELECT COUNT (*) FROM Silver.erp_cust_az12

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';


        -- Loading erp_loc_a101
        SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_loc_a101';
TRUNCATE TABLE Silver.erp_loc_a101
PRINT '>> Inserting Data Into: silver.erp_loc_a101';
INSERT INTO Silver.erp_loc_a101(
      CID,
      cntry)

SELECT
      REPLACE(CID,'-','') as CID,
      CASE WHEN cntry = 'DE' THEN 'India'
           WHEN cntry IN ('US','USA') THEN 'United states'
      ELSE cntry
      END as cntry
FROM Bronze.erp_loc_a101

SELECT COUNT(*) FROM Silver.erp_loc_a101

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		

		-- Loading erp_px_cat_g1v2
		SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
TRUNCATE TABLE Silver.erp_px_cat_g1v2
PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
INSERT INTO  Silver.erp_px_cat_g1v2(
      id,
      cat,
      subcat,
      maintenance)

SELECT 
      id,
      cat,
      subcat,
      maintenance
FROM BRONZE.erp_px_cat_g1v2

SELECT COUNT (*) FROM Silver.erp_px_cat_g1v2
SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
