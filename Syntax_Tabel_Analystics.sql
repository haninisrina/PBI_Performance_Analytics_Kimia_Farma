CREATE TABLE kimia_farma.kf_analytics AS
SELECT
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price as actual_price,
  ft.discount_percentage,
  CASE
    WHEN p.price <=50000 THEN 0.10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  (p.price * (1 - ft.discount_percentage )) AS nett_sales,
  (p.price * (1 - ft.discount_percentage ))* (
        CASE
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            ELSE 0.30
        END
    ) AS nett_profit,
  ft.rating AS rating_transaksi
FROM `rakamin-kf-analytics-463308.kimia_farma.kf_final_transaction`as ft 
LEFT JOIN `rakamin-kf-analytics-463308.kimia_farma.kf_kantor_cabang`as kc ON ft.branch_id = kc.branch_id 
LEFT JOIN `rakamin-kf-analytics-463308.kimia_farma.kf_product`as p ON ft.product_id = p.product_id