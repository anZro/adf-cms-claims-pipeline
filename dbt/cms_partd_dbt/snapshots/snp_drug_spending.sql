{% snapshot snp_drug_spending %}
{{
    config(
        target_schema='silver',
        unique_key='spending_key',
        strategy='check',
        check_cols=[
            'total_spending',
            'avg_spend_per_unit',
            'outlier_flag'
        ],
        invalidate_hard_deletes=True
    )
}}
SELECT
    {{ dbt_utils.generate_surrogate_key(
        ['brand_name', 'generic_name', 'manufacturer_name', 'spend_year']
    ) }}                AS spending_key,
    brand_name,
    generic_name,
    manufacturer_name,
    spend_year,
    total_spending,
    avg_spend_per_unit,
    outlier_flag
FROM {{ ref('fct_drug_spending') }}
{% endsnapshot %}
