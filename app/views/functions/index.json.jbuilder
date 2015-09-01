json.array!(@functions) do |function|
  json.extract! function, :id, :name, :short_name, :mission
  json.url function_url(function, format: :json)
end
