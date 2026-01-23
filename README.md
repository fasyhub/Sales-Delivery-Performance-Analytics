# Ecommerce-Delivery-Performance-Dashboard
End-to-end e-commerce analytics project using SQL, Power BI, and Python to analyze sales, delivery delays, and revenue risk.

Project Objective : 

The objective of this project is to analyze e-commerce order-level data to identify revenue trends, delivery performance issues, and customer distribution patterns, and convert findings into actionable business insights.


Key Business Questions Answered :

* How are total orders and revenue trending over time?
* What percentage of orders are delivered late?
* Which customer states generate the highest revenue?
* Which states have the highest delivery delay rates?
* How does delivery performance vary across customer states?


Data Preparation & Tools Used :

* Data cleaning and transformation were performed using SQL staging tables in PostgreSQL.
* Python was used only for exploratory data analysis (EDA) and data validation.
* Power BI was used for data modeling, DAX measures, and dashboard visualization.


Key Metrics \& KPIs :

* Total Orders
* Total Revenue
* On-Time Orders
* Delayed Orders
* Order Delay Rate (%)
* Total Customers
* Delayed Revenue
* Revenue at Risk (%)

The repository is organized as follows :

├── data/
│   ├── raw/
│   │   └── olist_raw.csv
│   └── cleaned/
│       └── olist_cleaned.csv
│
├── sql/
│   ├── create_tables.sql
│   ├── fact_orders.sql
│   └── business_metrics.sql
│
├── notebooks/
│   └── eda_validation.ipynb
│
├── dashboard/
│   └── olist_powerbi_dashboard.pbix
│
└── README.md

Key Insights :

* ~92% of orders were delivered on time, with ~8% experiencing delays.
* Delivery delays are disproportionately higher in certain customer states, indicating potential logistics bottlenecks.
* Revenue shows a stable trend despite fluctuations in order volume.
* Customer concentration by state highlights regional demand patterns that can guide warehouse and delivery optimization.
