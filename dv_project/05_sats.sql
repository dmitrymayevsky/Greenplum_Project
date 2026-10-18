insert into sat_order_line_measures
    (order_line_hk, load_date, hashdiff, ship_mode, sales, quantity, discount, profit, record_source)
select
    ol.order_line_hk,
    current_timestamp,
    md5(coalesce(st.ship_mode,'') || '|' || coalesce(st.sales::text,'') || '|' ||
        coalesce(st.quantity::text,'') || '|' || coalesce(st.discount::text,'') || '|' ||
        coalesce(st.profit::text,''))::char(32),
    st.ship_mode, st.sales, st.quantity, st.discount, st.profit,
    'SampleSuperstore.csv'
from stg_superstore st
join hub_order_line ol on ol.business_key =
    st.ship_mode || '|' || st.city || '|' || st.state || '|' || st.postal_code || '|' ||
    st.category || '|' || st.sub_category || '|' || st.sales || '|' || st.quantity || '|' ||
    st.discount || '|' || st.profit
where not exists (
    select 1 from sat_order_line_measures so
    where so.order_line_hk = ol.order_line_hk
      and so.hashdiff = md5(coalesce(st.ship_mode,'') || '|' || coalesce(st.sales::text,'') || '|' ||
        coalesce(st.quantity::text,'') || '|' || coalesce(st.discount::text,'') || '|' ||
        coalesce(st.profit::text,''))::char(32)
);

insert into sat_location_details (location_hk, load_date, hashdiff, country, region, record_source)
select distinct
    md5(coalesce(st.postal_code,'') || '|' || coalesce(st.city,'') || '|' || coalesce(st.state,''))::char(32),
    current_timestamp,
    md5(coalesce(st.country,'') || '|' || coalesce(st.region,''))::char(32),
    st.country, st.region, 'SampleSuperstore.csv'
from stg_superstore st
where st.postal_code is not null and st.city is not null and st.state is not null
  and not exists (
      select 1 from sat_location_details sl
      where sl.location_hk = md5(coalesce(st.postal_code,'') || '|' || coalesce(st.city,'') || '|' || coalesce(st.state,''))::char(32)
        and sl.hashdiff = md5(coalesce(st.country,'') || '|' || coalesce(st.region,''))::char(32)
  );

insert into sat_product_details (product_hk, load_date, hashdiff, category, sub_category, record_source)
select distinct
    md5(coalesce(category,'') || '|' || coalesce(sub_category,''))::char(32),
    current_timestamp,
    md5(coalesce(category,'') || '|' || coalesce(sub_category,''))::char(32),
    category, sub_category, 'SampleSuperstore.csv'
from stg_superstore
where category is not null and sub_category is not null
  and not exists (
      select 1 from sat_product_details sp
      where sp.product_hk = md5(coalesce(category,'') || '|' || coalesce(sub_category,''))::char(32)
  );
