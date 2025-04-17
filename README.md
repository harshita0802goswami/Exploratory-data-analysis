# Exploratory Data Analysis (EDA) on Financial Analytics - SQL
## Problem Statement  
As AtliQ Hardware expanded globally, the company faced significant data management challenges. Initially relying on Excel, the company struggled with large datasets, leading to frequent crashes and operational disruptions. A transition to MySQL was implemented to manage the growing data effectively and support the company's expansion.

## Project Overiew
The goal of this analysis is to provide a comprehensive view of AtliQ Hardware’s financial health and identify areas for performance optimization. Specifically, the analysis aims to:

- **Track profitability and revenue trends by market**
- **Identify consistently underperforming products**
- **Evaluate cost structures to highlight unprofitable SKUs**
- **Automate recurring business reporting**
- **Understand sales patterns across time and geographies**

##  Business Questions Addressed
- **Which markets are the most/least profitable?**
- **Are there products with consistently low sales across all markets?**
- **Are any SKUs priced below their production and distribution costs?**
- **How do customer segments perform year-over-year?**
- **What is the product-level contribution to total revenue?**
- **How is financial performance changing across fiscal years?**

## Deep-Dive Explorations
- **Profit and Loss Statements** : Calculated company-wide revenue, costs, and profits to evaluate overall financial performance.
- **Product-Level Analysis** : Assessed SKUs by sales, revenue, and cost to pinpoint high-performing and low-performing products.
- **Customer Drilldowns** : Used stored procedures to dynamically analyze customer-level performance by fiscal year.
- **Unproductive SKUs** : Identified low-demand products across markets, highlighting opportunities for discounting or discontinuation.
- **Yearly Financial Analysis** : Explored year-over-year trends to assess business growth and seasonal performance. Created a fiscal year and quater UDF to ensure accuracy.
