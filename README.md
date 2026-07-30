# Sales & Delivery Performance Analytics : 

An end-to-end analytics project using **SQL, Power BI, and Python** to analyze e-commerce order performance, delivery delays, and associated revenue risk, with the goal of identifying operational inefficiencies and improvement opportunities.

---

## Project Objective

The objective of this project is to analyze order-level e-commerce data in order to:
- Monitor sales and order trends over time  
- Measure delivery delay performance  
- Quantify revenue impacted by delayed deliveries  
- Identify customer regions with higher operational risk  

---

## Key Business Questions Answered

- How are total orders and revenue trending over time?
- What percentage of orders are delivered late?
- How much revenue is associated with delayed deliveries?
- Which customer states generate the highest revenue?
- Which states experience the highest delivery delay rates?

---

## Tools & Technologies

- **PostgreSQL** – data cleaning, staging tables, and fact table creation  
- **Python** – exploratory data analysis (EDA) and data validation  
- **Power BI** – data modeling, DAX measures, and interactive dashboard design  

---

## Key Metrics & KPIs

- Total Orders  
- Total Revenue  
- Total Customers  
- On-Time Orders  
- Delayed Orders  
- Order Delay Rate (%)  
- Delayed Revenue  
- Revenue at Risk (%)  

---

## Dashboard Overview

The Power BI dashboard provides:
- KPI cards summarizing order volume, delivery performance, and revenue risk  
- Trend analysis of orders and revenue over time  
- State-level analysis of order volume, revenue, and delay rates  
- Interactive filtering by customer state  

The dashboard is designed for **operations, logistics, and business stakeholders** to support data-driven decision-making.

---

## Repository Structure

├── data/
│ ├── raw/
│ │ └── .gitkeep
│ └── cleaned/
│ └── .gitkeep
│
├── sql/
│ ├── create_tables.sql
│ ├── fact_orders.sql
│ └── business_metrics.sql
│
├── notebooks/
│ └── eda_validation.ipynb
│
├── dashboard/
│ └── olist_powerbi_dashboard.pbix
│
└── README.md


---

## Data Availability

The raw and cleaned datasets are not included in this repository due to GitHub file size limitations.

**Dataset Source:**  
Brazilian E-Commerce Public Dataset (Olist) – Kaggle

All data transformations, business logic, and KPI calculations are fully reproducible using the provided SQL scripts and Python notebook.

---

## Key Insights

- Approximately **92% of orders were delivered on time**, while **~8% experienced delivery delays**
- Delayed orders contribute to a measurable portion of total revenue, indicating **revenue exposure due to logistics performance**
- Delivery delays are concentrated in specific customer states, highlighting potential regional fulfillment bottlenecks
- Revenue and order trends remain stable overall, despite variations in delivery performance across regions

---

## Business Value

This project demonstrates how operational metrics and delivery performance can be translated into **financial impact metrics**, enabling stakeholders to prioritize logistics improvements and reduce revenue risk.
