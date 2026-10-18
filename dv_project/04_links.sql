insert into link_order_line_segment (link_ols_hk, order_line_hk, segment_hk, load_date, record_source)
select distinct
    md5(ol.order_line_hk || '|' || s.segment_hk)::char(32),
    ol.order_line_hk, s.segment_hk, current_timestamp, 'SampleSuperstore.csv'
from hub_order_line ol
join stg_superstore st on ol.business_key =
    st.ship_mode || '|' || st.city || '|' || st.state || '|' || st.postal_code || '|' ||
    st.category || '|' || st.sub_category || '|' || st.sales || '|' || st.quantity || '|' ||
    st.discount || '|' || st.profit
join hub_segment s on s.segment_name = st.segment;

insert into link_order_line_location (link_oll_hk, order_line_hk, location_hk, load_date, record_source)
select distinct
    md5(ol.order_line_hk || '|' || l.location_hk)::char(32),
    ol.order_line_hk, l.location_hk, current_timestamp, 'SampleSuperstore.csv'
from hub_order_line ol
join stg_superstore st on ol.business_key =
    st.ship_mode || '|' || st.city || '|' || st.state || '|' || st.postal_code || '|' ||
    st.category || '|' || st.sub_category || '|' || st.sales || '|' || st.quantity || '|' ||
    st.discount || '|' || st.profit
join hub_location l on l.postal_code = st.postal_code and l.city = st.city and l.state = st.state;

insert into link_order_line_product (link_olp_hk, order_line_hk, product_hk, load_date, record_source)
select distinct
    md5(ol.order_line_hk || '|' || p.product_hk)::char(32),
    ol.order_line_hk, p.product_hk, current_timestamp, 'SampleSuperstore.csv'
from hub_order_line ol
join stg_superstore st on ol.business_key =
    st.ship_mode || '|' || st.city || '|' || st.state || '|' || st.postal_code || '|' ||
    st.category || '|' || st.sub_category || '|' || st.sales || '|' || st.quantity || '|' ||
    st.discount || '|' || st.profit
join hub_product p on p.category = st.category and p.sub_category = st.sub_category;
