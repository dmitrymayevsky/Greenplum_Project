delete from sat_order_line_measures;

insert into sat_order_line_measures
    (order_line_hk, load_date, hashdiff, ship_mode, sales, quantity, discount, profit, record_source)
select
    ol_hk,
    current_timestamp + (row_number() over (order by ol_hk) || ' microseconds')::interval,
    hashdiff,
    ship_mode, sales, quantity, discount, profit,
    'SampleSuperstore.csv'
from (
    select distinct on (ol_hk)
        md5(coalesce(ship_mode,'') || '|' || coalesce(city,'') || '|' || coalesce(state,'') || '|' ||
            coalesce(postal_code,'') || '|' || coalesce(category,'') || '|' || coalesce(sub_category,'') || '|' ||
            coalesce(sales::text,'') || '|' || coalesce(quantity::text,'') || '|' ||
            coalesce(discount::text,'') || '|' || coalesce(profit::text,''))::char(32) as ol_hk,
        md5(coalesce(ship_mode,'') || '|' || coalesce(sales::text,'') || '|' ||
            coalesce(quantity::text,'') || '|' || coalesce(discount::text,'') || '|' ||
            coalesce(profit::text,''))::char(32) as hashdiff,
        ship_mode, sales, quantity, discount, profit
    from stg_superstore
    where ship_mode is not null and city is not null and state is not null
      and postal_code is not null and category is not null and sub_category is not null
      and sales is not null and quantity is not null
      and discount is not null and profit is not null
    order by ol_hk
) x;
