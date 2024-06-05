with
    customers as (

        select * from {{ ref("stg_jaffle_shop__customers") }}

        ),

    payments as (

        select 
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders,
            sum(amount) amount 
        from {{ ref("fct_orders") }} 
        group by all

        ),

    final as (

        select
            c.customer_id,
            c.first_name,
            c.last_name,
            p.first_order_date,
            p.most_recent_order_date,
            coalesce(p.number_of_orders, 0) as number_of_orders,
            p.amount as lifetime_value
        from customers c
        left join payments p using (customer_id)

    )

select * from final
