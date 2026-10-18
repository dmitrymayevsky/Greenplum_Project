delete from link_order_line_segment;

insert into link_order_line_segment (link_ols_hk, order_line_hk, segment_hk, load_date, record_source)
select
    md5(ol_hk || '|' || seg_hk)::char(32),
    ol_hk,
    seg_hk,
    current_timestamp,
    'SampleSuperstore.csv'
from (
    select distinct on (ol_hk)
        md5(coalesce(ship_mode,'') || '|' || coalesce(city,'') || '|' || coalesce(state,'') || '|' ||
            coalesce(postal_code,'') || '|' || coalesce(category,'') || '|' || coalesce(sub_category,'') || '|' ||
            coalesce(sales::text,'') || '|' || coalesce(quantity::text,'') || '|' ||
            coalesce(discount::text,'') || '|' || coalesce(profit::text,''))::char(32) as ol_hk,
        md5(segment)::char(32) as seg_hk
    from stg_superstore
    where segment is not null
      and ship_mode is not null and city is not null and state is not null
      and postal_code is not null and category is not null and sub_category is not null
      and sales is not null and quantity is not null
      and discount is not null and profit is not null
    order by ol_hk
) x;
