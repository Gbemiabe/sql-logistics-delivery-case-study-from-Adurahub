-- Project 3 — SQL Case Study (SQLite/PostgreSQL-friendly)
-- Dataset: Olist Logistics & Delivery KPI sample (order-level)
-- Grain: 1 row = 1 order

-- You can run this in:
-- - SQLite (DB Browser for SQLite)
-- - PostgreSQL (minor type tweaks)
-- - BigQuery (convert types)

DROP TABLE IF EXISTS deliveries;

CREATE TABLE deliveries (
  order_id TEXT PRIMARY KEY,
  order_status TEXT,
  order_purchase_timestamp TEXT,              -- ISO datetime
  order_delivered_customer_date TEXT,         -- ISO datetime
  order_estimated_delivery_date TEXT,         -- ISO datetime/date
  purchase_month TEXT,                        -- YYYY-MM
  customer_city TEXT,
  customer_state TEXT,
  items INTEGER,
  unique_products INTEGER,
  unique_sellers INTEGER,
  items_value_brl REAL,
  freight_brl REAL,
  payment_value_brl REAL,
  review_score REAL,
  delivery_days REAL,
  delay_days_vs_estimate REAL,
  on_time_flag INTEGER,                       -- 1 yes, 0 no
  late_flag INTEGER                           -- 1 yes, 0 no
);

-- Optional: Helpful indexes
CREATE INDEX IF NOT EXISTS idx_deliveries_month ON deliveries(purchase_month);
CREATE INDEX IF NOT EXISTS idx_deliveries_state ON deliveries(customer_state);
CREATE INDEX IF NOT EXISTS idx_deliveries_status ON deliveries(order_status);
