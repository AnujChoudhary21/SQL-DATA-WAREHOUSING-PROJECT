/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customer AS
SELECT 
      ROW_NUMBER () OVER ( ORDER BY cst_id) as customer_key, --customer_key is surrogate key
      ci.cst_id AS customer_id,
      ci.cst_key AS customer_number,
      ci.cst_firstname AS first_name,
      ci.cst_lastname AS last_name,
      cl.cntry as country,
      ci.cst_marital_status AS marital_status,
      CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is master for gender
      ELSE ca.gen
      END as new_gender ,
      ca.bdate as birth_date,
      ci.cst_create_date AS create_date
FROM Silver.crm_cust_info as ci
LEFT JOIN Silver.erp_cust_az12 as ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 as cl
ON ci.cst_key = cl.cid

GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_product AS
SELECT
      ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) as product_key,
      pr.prd_id AS product_id,         -- Surrogate key
      pr.prd_key AS product_number,  
      pr.prd_nm AS product_name,
      pr.prd_line,
      pr.cat_id AS category_id,
      pc.cat as category,
      pc.subcat as subcategory,
      pc.maintenance,
      pr.prd_cost AS cost,
      pr.prd_start_dt as start_date
from Silver.crm_prd_info AS pr
INNER JOIN  Silver.erp_px_cat_g1v2 as pc
ON pr.cat_id = pc.id
where pr.prd_end_dt is null -- filter out historical data

GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sale AS
SELECT 
      sls_ord_num AS order_number,
      pr.product_key ,            
      cu.customer_key,
      sls_order_dt AS order_date,
      sls_ship_dt AS ship_date,
      sls_due_dt AS due_date,
      sls_sales AS sales_amount,
      sls_quantity AS quantity,
      sls_price AS price
FROM Silver.crm_sales_details AS sd
LEFT JOIN gold.dim_product AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer AS cu
ON sd.sls_cust_id = cu.customer_id
