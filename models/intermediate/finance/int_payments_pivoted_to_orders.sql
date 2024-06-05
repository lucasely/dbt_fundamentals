{%- set payment_methods = ['bank_transfer','credit_card','coupon','gift_card'] -%}

with

payments as (

   select * from {{ ref('stg_stripe__payments') }}

),

pivot_and_aggregate_payments_to_order_grain as (

   select
      order_id,
      {% for payment_method in payment_methods -%}

         sum(
            case
               when payment_method = '{{ payment_method }}'
               then amount
               else 0
            end
         ) as {{ payment_method }}_amount,

      {%- endfor %}
      sum(amount) as total_amount

   from payments
   where status = 'success'
   group by 1

)

select * from pivot_and_aggregate_payments_to_order_grain