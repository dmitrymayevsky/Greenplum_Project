create table stg_superstore (
    ship_mode varchar(50),
    segment varchar(50),
    country varchar(100),
    city varchar(100),
    state varchar(100),
    postal_code varchar(20),
    region varchar(50),
    category varchar(100),
    sub_category varchar(100),
    sales numeric(12,4),
    quantity int,
    discount numeric(8,4),
    profit numeric(12,4)
)
distributed randomly;
