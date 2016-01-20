json.array!(@goals) do |goal|
  json.extract! goal, :id, :name, :team_id, :group_id, :parent_goal_id
  json.url goal_url(goal, format: :json)
end
