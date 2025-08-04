{{ config(materialized="table", alias="stg_amazon_data", schema="staging") }}
{% if target.name == "prod" %}
    select
        transactionid,
        deliverydate,
        productdescription,
        pricedollar,
        shipment,
        age,
        'prod' as env
    from {{ source("amazon_src_data", "amazon_toys") }}
{% elif target.name == "dev" %}
    select
        transactionid,
        deliverydate,
        productdescription,
        pricedollar,
        shipment,
        age,
        'dev' as env
    from {{ source("amazon_src_data", "amazon_toys") }}
    limit 100
{% else %}
    select
        transactionid,
        deliverydate,
        productdescription,
        pricedollar,
        shipment,
        age,
        'default' as env
    from {{ source("amazon_src_data", "amazon_toys") }}
    limit 10
{% endif %}

qualify row_number() over (partition by transactionid order by deliverydate desc) = 1
