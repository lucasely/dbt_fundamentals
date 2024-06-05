with

    orders as (

        select * from {{ ref('stg_jaffle_shop__orders') }}

    ),

    payments as (

        select * from {{ ref('stg_stripe__payments') }}
        where status = 'success'

    )

select 
    o.order_id,
    p.order_date,
    o.customer_id,
    sum(p.amount) amount
from orders o 
left join payments p using (order_id)
group by all