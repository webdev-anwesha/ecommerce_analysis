
# 🛒 E-Commerce Analysis

## Why I Built This
I wanted to work on a real-world dataset to understand how an actual 
e-commerce business operates — not just clean toy data. 
The Olist dataset has 100K+ orders from a Brazilian marketplace, 
which made it perfect for finding genuine business insights.

---

## What I Found (The Interesting Stuff)
- **97% of customers never came back** — Olist has a serious retention problem
- **São Paulo dominates everything** — 40% of customers, fastest delivery too
- **RJ customers wait 12.8 days extra** when orders are late — worst in Brazil
- **Beauty & Health makes more money than Bed/Bath** despite fewer sales — higher price points
- Revenue grew 10x from late 2016 to mid 2018, then plateaued

---

## Tools & Why I Used Them
- **Python + Pandas** — data cleaning and merging 5 tables together
- **Matplotlib + Seaborn** — visualizing trends and distributions
- **PostgreSQL** — writing analytical queries the way a data analyst would at a real job
- **Jupyter Notebook** — keeping analysis readable and reproducible

---

## Dataset
Olist Brazilian E-Commerce — [Kaggle Link](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

5 tables: customers, orders, order items, payments, products
~100,000 orders between 2016 and 2018

---

## Project Structure
```
ecommerce_analysis/
├── data/          # Raw CSVs from Kaggle
├── notebooks/     # Jupyter analysis notebook
├── sql/           # PostgreSQL queries
├── visuals/       # All saved charts
└── README.md
```

## How to Run
```bash
git clone https://github.com/webdev-anwesha/ecommerce_analysis.git
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook
```
For SQL — import CSVs into PostgreSQL and run queries in `sql/olist_analysis.sql`

---

*Built by Anwesha as part of learning data analysis end to end.*
