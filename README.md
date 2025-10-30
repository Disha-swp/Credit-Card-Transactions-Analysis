# Credit-Card-Transactions-Analysis
This project analyzes credit card spending patterns using **MySQL** on a real-world dataset. The dataset contains transaction details across multiple cities in India, including transaction date, amount, card type, expense type, and gender.
The main objective is to perform **data cleaning**, **transformation**, and **exploratory analysis** using SQL queries and derive actionable insights.
### Dataset
**Source**: Kaggle - Analyzing Credit Card Spending Habits in India (https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

**Table Name**: credit_card_transcations
* **Columns**:
    * ind (INT)
    * city (VARCHAR)
    * date (DATE)
    * card_type (VARCHAR)
    * exp_type (VARCHAR)
    * gender (CHAR)
    * amount (INT)
### Data Preprocessing
* Renamed columns to **lowercase** and replaced spaces with underscores.
## Business Questions Solved
  ### 1. Top 5 Cities by Spending
  * Query to calculate **total spends per city** and their **percentage contribution**.
  * **Insight**: The top cities contribute a significant share of total credit card transactions.
  ### 2. Highest Spend Month per Card Type
  * Identified the **month with maximum spend for each card type.**
  * **Insight**: Certain months show spikes in Gold and Platinum card usage.
  ### 3. Cumulative Spend Milestone
  * For each card type, found the **transaction when cumulative spend crossed ₹1,000,000.**
  * **Insight**: Platinum and Gold cards reached the milestone faster than others.
  ### 4. City with Lowest Gold Card Spend Contribution
  * Calculated percentage spend for Gold card across cities.
  * **Insight**: Smaller cities had minimal Gold card penetration.
  ### 5. Expense Type Insights per City
  * For each city, displayed **highest and lowest expense type.**
  * **Insight**: Bills and Entertainment dominate urban spends, while Fuel is least common.
  ### 6. Female Spend Contribution
  * Computed percentage contribution of **female spends for each expense type.**
  * **Insight**: Fashion and Entertainment show higher female engagement.
  ### 7. Highest MoM Growth (Jan 2014)
  * Identified the **card and expense type combination with maximum growth** from Dec 2013 to Jan 2014.
  * **Insight**: Gold cards in Entertainment saw the highest growth.
  ### 8. Weekend Spend Ratio
  * Found city with the highest **spend-to-transaction ratio** during weekends.
  * **Insight**: Metro cities exhibit higher weekend spend ratios.
  ### 9. Fastest 500 Transactions
  * Calculated **which city reached 500 transactions fastest after its first transaction**.
  * **Insight**: Tier-1 cities show rapid transaction activity.

## SQL Techniques Used
* Window Functions: ROW_NUMBER(), LAG(), LEAD(), DENSE_RANK()
* Date Functions: STR_TO_DATE(), MONTH(), YEAR(), DAYNAME()
* Aggregations: SUM(), COUNT(), ROUND()
* CTEs & Subqueries for complex calculations
* Case Statements for conditional logic

# Tableau Screenshot
<img width="1655" height="674" alt="image" src="https://github.com/user-attachments/assets/006cbc9b-fb02-4471-8bbd-6394b29e46ef" />

  
