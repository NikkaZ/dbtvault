{%- macro ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('ma_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                                                                  src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                                  src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}


{{- dbtvault.check_required_parameters(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                       src_payload=src_payload, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_cdk, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set cdk_cols = dbtvault.expand_column_list(columns=[src_cdk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'a') }}, {{ dbtvault.prefix(cdk_cols, 'a') }} )
        OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}) AS source_count
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.prefix([src_pk], 'a') }} IS NOT NULL
    {%- for child_key in src_cdk %}
        AND {{ dbtvault.multikey(child_key, 'a', condition='IS NOT NULL') }}
    {%- endfor %}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
        AND __PERIOD_FILTER__
    {% endif %}
    {%- set source_cte = "source_data" %}
),

{%- if model.config.materialized == 'vault_insert_by_rank' %}
rank_col AS (
    SELECT * FROM source_data
    WHERE __RANK_FILTER__
    {%- set source_cte = "rank_col" %}
),
{% endif -%}

{% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}

{# Select latest records from satellite together with count of distinct hashdiffs for each hashkey #}
latest_records AS (
    SELECT *, COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'latest') }}, {{ dbtvault.prefix(cdk_cols, 'latest') }} )
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'latest') }}) AS target_count
    FROM (
        SELECT {{ dbtvault.prefix(cdk_cols, 'target_records', alias_target='target') }}, {{ dbtvault.prefix(rank_cols, 'target_records', alias_target='target') }}
            ,CASE WHEN RANK()
                OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'target_records') }}
                    ORDER BY {{ dbtvault.prefix([src_ldts], 'target_records') }} DESC) = 1
            THEN 'Y' ELSE 'N' END AS latest
        FROM {{ this }} AS target_records
        INNER JOIN
            (SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_pks') }}
            FROM {{ source_cte }} AS source_pks) AS source_data
                ON {{ dbtvault.prefix([src_pk], 'target_records') }} = {{ dbtvault.prefix([src_pk], 'source_data') }}
        QUALIFY latest = 'Y'
    ) AS latest
),

{# Select PKs and hashdiff counts for matching stage and sat records #}
{# Matching by hashkey + hashdiff + cdk #}
matching_records AS (
    SELECT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
        ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'stage') }}, {{ dbtvault.prefix(cdk_cols, 'stage') }}) AS match_count
    FROM {{ source_cte }} AS stage
    INNER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records', alias_target='target') }}
        AND {{ dbtvault.prefix([src_hashdiff], 'stage') }} = {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }}
    {%- for child_key in src_cdk %}
        AND {{ dbtvault.prefix([child_key], 'stage') }} = {{ dbtvault.prefix([child_key], 'latest_records') }}
    {%- endfor %}
    GROUP BY {{ dbtvault.prefix([src_pk], 'stage') }}
),

{# Select stage records with PKs that exist in sat where hashdiffs differ #}
{# either where total counts differ or where match counts differ  #}
satellite_update AS (
    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
    FROM {{ source_cte }} AS stage
    INNER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'latest_records') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    LEFT OUTER JOIN matching_records
        ON {{ dbtvault.prefix([src_pk], 'matching_records') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
    WHERE stage.source_count != latest_records.target_count
        OR COALESCE(matching_records.match_count, 0) != latest_records.target_count
),

{# Select stage records with PKs that do not exist in sat #}
satellite_insert AS (
    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
    FROM {{ source_cte }} AS stage
    LEFT OUTER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
    WHERE {{ dbtvault.prefix([src_pk], 'latest_records') }} IS NULL
),

{%- endif %}

records_to_insert AS (
    SELECT {% if not (dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental()) %} DISTINCT {% endif %} {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM {{ source_cte }} AS stage
    {# Restrict to "to-do lists" of keys selected by satellite_update and satellite_insert CTEs #}
    {% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}
    INNER JOIN satellite_update
        ON {{ dbtvault.prefix([src_pk], 'satellite_update') }} = {{ dbtvault.prefix([src_pk], 'stage') }}

    UNION

    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM {{ source_cte }} AS stage
    INNER JOIN satellite_insert
        ON {{ dbtvault.prefix([src_pk], 'satellite_insert') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    {%- endif %}
)

{# Select stage records #}
SELECT * FROM records_to_insert

{%- endmacro -%}