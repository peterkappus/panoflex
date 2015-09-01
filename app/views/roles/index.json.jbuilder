json.array!(@roles) do |role|
  json.extract! role, :id, :name, :title, :type, :monthly_cost, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec, :jan, :feb, :mar, :comments, :function_name, :team
  json.url role_url(role, format: :json)
end
