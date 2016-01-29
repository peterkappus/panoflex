json.array!(@scores) do |score|
  json.extract! score, :id, :amount, :reason, :goal_id
  json.url score_url(score, format: :json)
end
