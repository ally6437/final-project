json.extract! payment, :id, :order_id, :status, :created_at, :updated_at
json.url payment_url(payment, format: :json)
