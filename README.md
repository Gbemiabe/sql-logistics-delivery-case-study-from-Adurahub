# SQL Case Study — Logistics & Delivery (Olist)

This repository demonstrates core **SQL analyst** skills using an order-level delivery KPI dataset derived from the Olist public dataset.

## What this analysis answers
- On-time delivery rate and monthly trend
- Delivery speed (delivery days) trend
- Top states by volume and performance
- Late delivery risk by state
- Freight cost vs delivery speed
- Customer experience impact (review score vs on-time)

## Files
- `schema.sql` — creates the `deliveries` table + indexes
- `queries.sql` — 15 business queries
- `answers.md` — how to run + business framing
- `data/olist_delivery_kpis_sample_20000.csv` — representative sample dataset

## How to run (SQLite)
1) Run `schema.sql`
2) Import the CSV into `deliveries`
3) Execute queries in `queries.sql`
