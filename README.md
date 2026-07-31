# SQL-DATA-WAREHOUSING-PROJECT
Building a modern data warehouse with SQL Server, including ETL processes, data modeling, and analytics
Data Warehouse and Analytics Project
Welcome to the Data Warehouse and Analytics Project repository! 🚀
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

🏗️ **Data Architecture**
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers: Data Architecture

<img width="6235" height="3216" alt="image" src="https://github.com/user-attachments/assets/db31793f-f813-4866-92ca-9351bc078d88" />


Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.
📖 **Project Overview**
This project involves:

Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
Data Modeling: Developing fact and dimension tables optimized for analytical queries.
Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

🚀 **Project Requirements**
Building the Data Warehouse (Data Engineering)
Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications
Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
Data Quality: Cleanse and resolve data quality issues prior to analysis.
Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
Scope: Focus on the latest dataset only; historization of data is not required.
Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.
BI: Analytics & Reporting (Data Analysis)

Objective
Develop SQL-based analytics to deliver detailed insights into:
Customer Behavior
Product Performance
Sales Trends
These insights empower stakeholders with key business metrics, enabling strategic decision-making.

For more details, refer to docs/requirements.md.

📂 **Repository Structure**
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project


🛡️ **License**
This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.

🌟 **About Me**
Hi there, I'm Anuj Choudhary 👋

🎓 M.Pharm Research Scholar  at **Indian Institute of Technology (BHU), Varanasi**.

I am passionate about **Data Analytics, Business Intelligence, and Data-Driven Decision Making**. My goal is to combine my strong pharmaceutical research background with analytics to solve real-world healthcare and business problems.

## 🚀 About Me

- 🎓 M.Pharm Research Scholar at IIT (BHU), Varanasi
- 💊 Strong domain knowledge in Pharmaceutical Sciences, Pharmacognosy, and Drug Research
- 📊 Passionate about Data Analytics and Business Intelligence
- 💻 Skilled in SQL (SQL Server & MySQL) from Basic to Advanced
- 📈 Proficient in Microsoft Power BI for data visualization and dashboard development
- 🧹 Experience with data cleaning, querying, reporting, and business insights
- 💼 Interested in Healthcare Analytics, Pharma Analytics, Clinical Data, and Business Intelligence
- 🚀 Knowledge of Venture Capital, Startups, and Innovation Ecosystems
- 🌱 Always learning new technologies and improving analytical skills

## 🛠️ Technical Skills

**Languages & Databases**
- SQL Server
- MySQL

**Analytics & Visualization**
- Power BI
- Data Cleaning
- Data Analysis
- Dashboard Development
- Business Intelligence

**Domain Knowledge**
- Pharmaceutical Research
- Regulatory Affairs
- Healthcare & Pharma Analytics
- Clinical Research
- Formulation & Development

## 🎯 Current Focus

- Building real-world SQL projects
- Developing interactive Power BI dashboards
- Strengthening Business Analytics skills
- Exploring Healthcare and Pharma Analytics
- Contributing to open-source and analytics projects

## 🤝 Open to Opportunities

I am actively seeking **Internships**, **Trainee**, **Associate**, and **Entry-Level** opportunities in:

- Data Analytics
- Business Intelligence
- Healthcare Analytics
- Pharma Analytics
- SQL Developer
- Power BI Developer

I'm excited to learn, grow, and contribute to impactful projects while collaborating with talented professionals.

## 🌐 Let's Connect

- 💼 LinkedIn: www.linkedin.com/in/anuj-choudhary-552117321
- 📧 Email: anujchoudhary883@gmail.com
- 🐙 GitHub: https://github.com/AnujChoudhary21


⭐ Thanks for visiting my profile! Feel free to connect, collaborate, or reach out for exciting opportunities


