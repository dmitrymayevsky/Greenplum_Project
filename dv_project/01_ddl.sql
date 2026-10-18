-- хабы

create table hub_order_line (
    order_line_hk char(32) not null,
    business_key text not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_hub_order_line primary key (order_line_hk)
)
distributed by (order_line_hk);

create table hub_segment (
    segment_hk char(32) not null,
    segment_name varchar(50) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_hub_segment primary key (segment_hk)
)
distributed by (segment_hk);

create table hub_location (
    location_hk char(32) not null,
    postal_code varchar(20) not null,
    city varchar(100) not null,
    state varchar(100) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_hub_location primary key (location_hk)
)
distributed by (location_hk);

create table hub_product (
    product_hk char(32) not null,
    category varchar(100) not null,
    sub_category varchar(100) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_hub_product primary key (product_hk)
)
distributed by (product_hk);

-- линки

create table link_order_line_segment (
    link_ols_hk char(32) not null,
    order_line_hk char(32) not null,
    segment_hk char(32) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_link_ols primary key (link_ols_hk),
    constraint fk_lols_order foreign key (order_line_hk) references hub_order_line(order_line_hk),
    constraint fk_lols_segment foreign key (segment_hk) references hub_segment(segment_hk)
)
distributed by (link_ols_hk);

create table link_order_line_location (
    link_oll_hk char(32) not null,
    order_line_hk char(32) not null,
    location_hk char(32) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_link_oll primary key (link_oll_hk),
    constraint fk_loll_order foreign key (order_line_hk) references hub_order_line(order_line_hk),
    constraint fk_loll_location foreign key (location_hk) references hub_location(location_hk)
)
distributed by (link_oll_hk);

create table link_order_line_product (
    link_olp_hk char(32) not null,
    order_line_hk char(32) not null,
    product_hk char(32) not null,
    load_date timestamp not null,
    record_source varchar(100) not null,
    constraint pk_link_olp primary key (link_olp_hk),
    constraint fk_lolp_order foreign key (order_line_hk) references hub_order_line(order_line_hk),
    constraint fk_lolp_product foreign key (product_hk) references hub_product(product_hk)
)
distributed by (link_olp_hk);

-- сателлиты

create table sat_order_line_measures (
    order_line_hk char(32) not null,
    load_date timestamp not null,
    hashdiff char(32) not null,
    ship_mode varchar(50),
    sales numeric(12,4),
    quantity int,
    discount numeric(8,4),
    profit numeric(12,4),
    record_source varchar(100) not null,
    constraint pk_sat_olm primary key (order_line_hk, load_date),
    constraint fk_sat_olm foreign key (order_line_hk) references hub_order_line(order_line_hk)
)
distributed by (order_line_hk);

create table sat_location_details (
    location_hk char(32) not null,
    load_date timestamp not null,
    hashdiff char(32) not null,
    country varchar(100),
    region varchar(50),
    record_source varchar(100) not null,
    constraint pk_sat_loc primary key (location_hk, load_date),
    constraint fk_sat_loc foreign key (location_hk) references hub_location(location_hk)
)
distributed by (location_hk);

create table sat_product_details (
    product_hk char(32) not null,
    load_date timestamp not null,
    hashdiff char(32) not null,
    category varchar(100),
    sub_category varchar(100),
    record_source varchar(100) not null,
    constraint pk_sat_prod primary key (product_hk, load_date),
    constraint fk_sat_prod foreign key (product_hk) references hub_product(product_hk)
)
distributed by (product_hk);
