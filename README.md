# Project 1 — Sales Analytics using MySQL and Power BI

## Project objective
Analyze 100,001 sales transactions to understand revenue, profitability, customer activity, product/category performance, and regional trends.

## Dataset
Source file: `Sales_Analytics_100001_Rows_Dataset(1).xlsx`
Sheet: `Sales Data`
Rows: 100,001
Columns: 15
Date range in file: 2025-01-01 to 2026-12-31
Distinct customers: 300
Distinct products: 8

## Three-table model (as requested)
1. `DimCustomer`: Customer_Key (PK), Customer_ID, Customer_Name, Region, City
2. `DimProduct`: Product_Key (PK), Product_ID, Product_Name, Category
3. `FactSales`: Order_ID (PK), Order_Date, Customer_Key (FK), Product_Key (FK), Quantity, Unit_Price, Cost, Revenue, Profit, Margin_Percent

Relationships in Power BI:
- DimCustomer[Customer_Key] 1 -> * FactSales[Customer_Key]
- DimProduct[Product_Key] 1 -> * FactSales[Product_Key]
Both relationships should be active and single-direction.

## Files
- `SQL/01_Create_3_Table_Schema.sql`: creates target schema
- `SQL/02_Populate_3_Tables.sql`: populates dimensions and fact from the existing staging table
- `SQL/03_Data_Quality_and_Reconciliation.sql`: checks completeness and financial logic
- `SQL/04_Business_Analysis_Queries.sql`: core and advanced SQL analysis
- `PowerBI/DAX_Measures.txt`: DAX measures
- `PowerBI/Power_BI_Build_Guide.md`: report setup and visual layout
- `Documentation/Project_Report.docx`: portfolio report template with checked dataset metrics and example findings

## Run order
1. Import source Excel/CSV into MySQL as `Sales_Analytics` in database `SalesAnalytics`.
2. Run SQL 01.
3. Check customer/product mapping consistency before loading if you alter the source.
4. Run SQL 02 once on empty target tables.
5. Run SQL 03 and resolve any mismatches.
6. Run SQL 04 and save query results/screenshots.
7. Connect Power BI to MySQL and follow the build guide.
8. Replace any report placeholders with results from your own run.

## Data caveats
- The file has dates through 2026-12-31, which extend beyond the current date (2026-10-15). Confirm whether this is intentional/synthetic data before presenting it as historical real-world sales.
- Average Order Revenue (AOV proxy) is calculated as total revenue / distinct Order_ID. The source currently has one row per Order_ID.
- Profit margin is calculated as total profit / total revenue, not the average of row-level margin percentages.
- SQL inserts should only be run once into empty target tables. Do not drop the original source table.

## Dashboard Preview

![Sales Analytics Dashboard]([screenshots/sales_dashboard.png](https://1drv.ms/i/c/5A8C903FBB8DEA79/AT6sGdp2gE1OkEmJsB1r-OU?e=DK7hHc))
