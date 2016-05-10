module GoalsHelper
  def can_modify?(goal)
    is_admin? || current_user == goal.owner
  end
end
