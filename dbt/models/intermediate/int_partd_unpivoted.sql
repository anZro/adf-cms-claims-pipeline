WITH staging AS (
    SELECT * FROM {{ ref('stg_cms_partd') }}
),
unpivoted AS (
    {% for year in [2019, 2020, 2021, 2022, 2023] %}
    SELECT
        brand_name,
        generic_name,
        manufacturer_name,
        {{ year }}                              AS spend_year,
        total_spending_{{ year }}               AS total_spending,
        total_dosage_units_{{ year }}           AS total_dosage_units,
        total_claims_{{ year }}                 AS total_claims,
        total_beneficiaries_{{ year }}          AS total_beneficiaries,
        avg_spend_per_unit_{{ year }}           AS avg_spend_per_unit,
        avg_spend_per_claim_{{ year }}          AS avg_spend_per_claim,
        avg_spend_per_bene_{{ year }}           AS avg_spend_per_bene,
        outlier_flag_{{ year }}                 AS outlier_flag,
        yoy_unit_cost_change_22_23,
        cagr_unit_cost_19_23,
        _source_file,
        _loaded_at
    FROM staging
    {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
)
SELECT * FROM unpivoted
WHERE total_spending > 0
