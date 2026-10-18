insert into hub_order_line (order_line_hk, business_key, load_date, record_source)
select distinct
    md5(coalesce(ship_mode,'') || '|' || coalesce(city,'') || '|' || coalesce(state,'') || '|' ||
        coalesce(postal_code,'') || '|' || coalesce(category,'') || '|' || coalesce(sub_category,'') || '|' ||
        coalesce(sales::text,'') || '|' || coalesce(quantity::text,'') || '|' ||
        coalesce(discount::text,'') || '|' || coalesce(profit::text,''))::char(32),
    ship_mode || '|' || city || '|' || state || '|' || postal_code || '|' ||
    category || '|' || sub_category || '|' || sales || '|' || quantity || '|' ||
    discount || '|' || profit,
    current_timestamp,
    'SampleSuperstore.csv'
from stg_superstore;

insert into hub_segment (segment_hk, segment_name, load_date, record_source)
select distinct md5(segment)::char(32), segment, current_timestamp, 'SampleSuperstore.csv'
from stg_superstore where segment is not null;

insert into hub_location (location_hk, postal_code, city, state, load_date, record_source)
select distinct
    md5(coalesce(postal_code,'') || '|' || coalesce(city,'') || '|' || coalesce(state,''))::char(32),
    postal_code, city, state, current_timestamp, 'SampleSuperstore.csv'
from stg_superstore
where postal_code is not null and city is not null and state is not null;

insert into hub_product (product_hk, category, sub_category, load_date, record_source)
select distinct
    md5(coalesce(category,'') || '|' || coalesce(sub_category,''))::char(32),
    category, sub_category, current_timestamp, 'SampleSuperstore.csv'
from stg_superstore
where category is not null and sub_category is not null;
