with

    orders as (

        select * from {{ ref('stg_jaffle_shop__orders') }}

    ),

    payments as (

        select * from {{ ref('stg_stripe__payments') }}
        where status = 'success'

    )

select 
    orders.order_id,
    payments.created_at,
    orders.customer_id,
    sum(payments.amount) as amount
from orders 
left join payments using (order_id)
group by all