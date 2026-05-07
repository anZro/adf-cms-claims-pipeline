WITH staging AS (
    SELECT * FROM {{ ref('stg_cms_partd') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['brand_name', 'generic_name']) }}
                                        AS drug_key,
    brand_name,
    generic_name,
    COUNT(DISTINCT manufacturer_name)   AS manufacturer_count,
    MAX(outlier_flag_2023)              AS current_outlier_flag,
    cagr_unit_cost_19_23,
    yoy_unit_cost_change_22_23
FROM staging
GROUP BY
    brand_name,
    generic_name,
    cagr_unit_cost_19_23,
    yoy_unit_cost_change_22_23
