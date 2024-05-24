with

    orders as (

        select * from {{ ref('stg_orders') }}

    ),

    payments as (

        select * from {{ ref('stg_stripe_payments') }}
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