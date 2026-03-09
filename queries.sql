-- Project 3 — SQL Queries (Business Questions)
-- Note: Most queries focus on delivered orders only.

-- Q1) Total orders, delivered orders, delivered %
SELECT
  COUNT(*) AS total_orders,
  SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
  ROUND(100.0 * SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) / COUNT(*), 2) AS delivered_pct
FROM deliveries;

-- Q2) On-time delivery rate (delivered only)
SELECT
  ROUND(100.0 * AVG(on_time_flag), 2) AS on_time_rate_pct
FROM deliveries
WHERE order_status = 'delivered';

-- Q3) Average delivery days (delivered only)
SELECT
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM deliveries
WHERE order_status = 'delivered';

-- Q4) Monthly trend: delivered volume + on-time rate + avg delivery days
SELECT
  purchase_month,
  COUNT(*) AS delivered_orders,
  ROUND(100.0 * AVG(on_time_flag), 2) AS on_time_rate_pct,
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY purchase_month
ORDER BY purchase_month;

-- Q5) Top 10 states by delivered volume
SELECT
  customer_state,
  COUNT(*) AS delivered_orders
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY delivered_orders DESC
LIMIT 10;

-- Q6) State performance: on-time rate + avg delivery days + avg freight (Top 10 by volume)
WITH state_perf AS (
  SELECT
    customer_state,
    COUNT(*) AS delivered_orders,
    AVG(on_time_flag) AS on_time_rate,
    AVG(delivery_days) AS avg_delivery_days,
    AVG(freight_brl) AS avg_freight_brl
  FROM deliveries
  WHERE order_status = 'delivered'
  GROUP BY customer_state
),
top_states AS (
  SELECT customer_state
  FROM state_perf
  ORDER BY delivered_orders DESC
  LIMIT 10
)
SELECT
  s.customer_state,
  sp.delivered_orders,
  ROUND(100.0 * sp.on_time_rate, 2) AS on_time_rate_pct,
  ROUND(sp.avg_delivery_days, 2) AS avg_delivery_days,
  ROUND(sp.avg_freight_brl, 2) AS avg_freight_brl
FROM top_states s
JOIN state_perf sp USING(customer_state)
ORDER BY sp.delivered_orders DESC;

-- Q7) Where is freight expensive? (Top 10 states by avg freight, delivered only)
SELECT
  customer_state,
  ROUND(AVG(freight_brl), 2) AS avg_freight_brl,
  COUNT(*) AS delivered_orders
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY customer_state
HAVING delivered_orders >= 200
ORDER BY avg_freight_brl DESC
LIMIT 10;

-- Q8) Late delivery share by state (Top 10 by late rate, delivered only)
SELECT
  customer_state,
  COUNT(*) AS delivered_orders,
  ROUND(100.0 * AVG(late_flag), 2) AS late_rate_pct
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY customer_state
HAVING delivered_orders >= 200
ORDER BY late_rate_pct DESC
LIMIT 10;

-- Q9) Freight vs delivery speed (state-level view)
SELECT
  customer_state,
  ROUND(AVG(freight_brl), 2) AS avg_freight_brl,
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY customer_state
HAVING COUNT(*) >= 200
ORDER BY avg_freight_brl DESC;

-- Q10) Average delay days for late orders only
SELECT
  ROUND(AVG(delay_days_vs_estimate), 2) AS avg_delay_days_late_only
FROM deliveries
WHERE order_status = 'delivered' AND late_flag = 1;

-- Q11) Customer experience: on-time vs review score
SELECT
  CASE WHEN on_time_flag = 1 THEN 'On-time' ELSE 'Late' END AS delivery_group,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_review_score
FROM deliveries
WHERE order_status = 'delivered' AND review_score IS NOT NULL
GROUP BY delivery_group
ORDER BY delivery_group;

-- Q12) High-risk lanes: high volume + below-average on-time rate
WITH overall AS (
  SELECT AVG(on_time_flag) AS overall_on_time
  FROM deliveries
  WHERE order_status = 'delivered'
),
state_perf AS (
  SELECT customer_state,
         COUNT(*) AS delivered_orders,
         AVG(on_time_flag) AS on_time_rate
  FROM deliveries
  WHERE order_status = 'delivered'
  GROUP BY customer_state
)
SELECT
  customer_state,
  delivered_orders,
  ROUND(100.0 * on_time_rate, 2) AS on_time_rate_pct
FROM state_perf, overall
WHERE delivered_orders >= 500 AND on_time_rate < overall_on_time
ORDER BY delivered_orders DESC;

-- Q13) Ops complexity: seller count vs delivery time
SELECT
  CASE
    WHEN unique_sellers = 1 THEN '1 seller'
    WHEN unique_sellers = 2 THEN '2 sellers'
    ELSE '3+ sellers'
  END AS seller_complexity,
  COUNT(*) AS delivered_orders,
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY seller_complexity
ORDER BY seller_complexity;

-- Q14) Biggest delays (Top 20 late orders by delay days)
SELECT
  order_id,
  customer_state,
  purchase_month,
  ROUND(delay_days_vs_estimate, 1) AS delay_days
FROM deliveries
WHERE order_status = 'delivered' AND late_flag = 1
ORDER BY delay_days_vs_estimate DESC
LIMIT 20;

-- Q15) Monthly late rate + average delay for late orders
SELECT
  purchase_month,
  COUNT(*) AS delivered_orders,
  ROUND(100.0 * AVG(late_flag), 2) AS late_rate_pct,
  ROUND(AVG(CASE WHEN late_flag = 1 THEN delay_days_vs_estimate END), 2) AS avg_delay_days_late_only
FROM deliveries
WHERE order_status = 'delivered'
GROUP BY purchase_month
ORDER BY purchase_month;
