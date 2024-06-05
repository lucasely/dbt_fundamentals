with
    customers as (

        select * from {{ ref("stg_jaffle_shop__customers") }}

        ),

    payments as (

        select 
            customer_id,
            min(created_at) as first_order_date,
            max(created_at) as most_recent_order_date,
            count(order_id) as number_of_orders,
            sum(amount) as amount 
        from {{ ref("fct_orders") }} 
        group by all

        ),

    final as (

        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            payments.first_order_date,
            payments.most_recent_order_date,
            coalesce(payments.number_of_orders, 0) as number_of_orders,
            payments.amount as lifetime_value
        from customers
        left join payments using (customer_id)

    )

select * from final
