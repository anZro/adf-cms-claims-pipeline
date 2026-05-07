WITH staging AS (
    SELECT * FROM {{ ref('stg_cms_partd') }}
)
SELECT
    brand_name,
    generic_name,
    manufacturer_name,
    cagr_unit_cost_19_23,
    yoy_unit_cost_change_22_23,
    total_spending_2023                 AS spending_2023,
    total_claims_2023                   AS claims_2023,
    total_beneficiaries_2023            AS beneficiaries_2023,
    avg_spend_per_unit_2023             AS avg_unit_cost_2023,
    outlier_flag_2023                   AS current_outlier_flag,
    CASE
        WHEN cagr_unit_cost_19_23 IS NULL  THEN 'New Drug (No History)'
        WHEN cagr_unit_cost_19_23 >= 0.10  THEN 'High Growth (>10% CAGR)'
        WHEN cagr_unit_cost_19_23 >= 0.05  THEN 'Moderate Growth (5-10% CAGR)'
        WHEN cagr_unit_cost_19_23 >= 0     THEN 'Low Growth (0-5% CAGR)'
        ELSE 'Declining Cost'
    END                                 AS cagr_category,
    _loaded_at
FROM staging
WHERE total_spending_2023 > 0
