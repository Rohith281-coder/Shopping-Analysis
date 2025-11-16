 Shopping Trends Analysis – SQL Project Project Overview

This project analyzes shopping trend data to uncover insights about customer behavior, spending patterns, and loyalty. The analysis uses SQL queries for data transformation, feature engineering, and customer segmentation using an RFM-like model (Recency, Frequency, Monetary).

 Files in Repository

ShoppingTrend Analysis.sql → SQL script for database creation, data transformation, segmentation, and insights.

README.md → Project documentation.

 Technologies Used

SQL (MySQL / MariaDB) – Database design, transformations, queries

RFM Segmentation – Customer segmentation technique (Monetary, Frequency, Engagement)

Dataset Attributes: Customer ID, Age, Gender, Item Purchased, Category, Purchase Amount, Subscription, Payment Method, Discounts, Location, Review Rating

 Key Features

Data Preprocessing

Standardized purchase frequency (daily, weekly, monthly, etc.).

Cleaned categorical values (gender, category, subscription, promo codes).

Created metrics for estimated total spend and estimated annual spend.

Customer Segmentation (RFM)

Monetary Score → based on total spend.

Frequency Score → based on purchases per year.

Engagement Score → subscription status + review ratings.

Segments: Champions, Big Spenders, Frequent Loyal, Low Value.

Analytical Queries

Segment distribution of customers.

Top 10 high-spending customers.

Spending insights by category and location.

Identification of high-value customers not subscribed.

Engagement distribution across customers.

 Example Insights

Distribution of customers across segments (Champions, Big Spenders, etc.).

Top 10 customers by estimated total spend.

Categories with the highest average spend.

Locations with the highest concentration of top customers.

Opportunities for targeted marketing (e.g., unsubscribed high spenders).

Project Workflow

Create Database → Shoppingtrend.

Build frequency_map → Map purchase frequency to numeric values.

Create customer_metrics → Feature engineering for each customer.

Apply RFM Segmentation → Assign scores & customer segments.

Run Analytical Queries → Extract insights for business strategy.

 Future Enhancements

Add recency (last purchase date) to RFM segmentation.

Create visual dashboards (Power BI/Tableau) from SQL results.

Automate query execution for regular reporting.

 Author

E ROHITH

B.Tech CSE (Specialization: Data Science)

Skills: SQL, Data Analysis, RFM Segmentation, Customer Analytics
