WITH unpivoted AS (
    SELECT * FROM {{ ref('int_partd_unpivoted') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(
        ['brand_name', 'generic_name', 'manufacturer_name', 'spend_year']
    ) }}                                AS spending_key,
    brand_name,
    generic_name,
    manufacturer_name,
    spend_year,
    total_spending,
    total_dosage_units,
    total_claims,
    total_beneficiaries,
    avg_spend_per_unit,
    avg_spend_per_claim,
    avg_spend_per_bene,
    outlier_flag,
    CASE WHEN outlier_flag = 1
        THEN 'Outlier' ELSE 'Standard'
    END                                 AS cost_category,
    ROUND(
        total_spending / NULLIF(total_beneficiaries, 0), 2
    )                                   AS spend_per_bene_derived,
    _loaded_at
FROM unpivoted
