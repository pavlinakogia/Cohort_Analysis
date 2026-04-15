# E-commerce Customer Cohort Analysis 

## Project Overview
This project analyzes customer retention for a UK-based online retail store. Using a dataset of over 500,000 transactions, I performed **Cohort Analysis** to understand how different customer groups behave over time.

## Key Insights
* **High Retention:** The December 2010 cohort showed a strong **36.6% retention** in its first month.
* **Seasonal Loyalty:** Customers acquired in late 2010 showed a significant **50% return rate** exactly 11 months later, indicating strong seasonal loyalty.

## Tech Stack
* **SQL (SQLite):** Data cleaning, date parsing, and retention matrix calculation.
* **Python (Pandas, Seaborn):** Data visualization and heatmap generation.

## Project Structure
- `sql_queries/`: SQL scripts for data processing.
- `scripts/`: Python code for visualization.
- `outputs/`: Final retention heatmap.

## How to Run
1. Run the SQL scripts in `sql_queries/` on the retail database.
2. Export results to `data/cohort_retention.csv`.
3. Execute `scripts/visualization.py` to generate the heatmap.
