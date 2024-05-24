select
    orderid as order_id,
    created as order_date,
    paymentmethod as payment_method,
    status,
    amount
from {{ source('stripe', 'payment') }}