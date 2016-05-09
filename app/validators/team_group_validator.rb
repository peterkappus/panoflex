class TeamGroupValidator < ActiveModel::Validator
  def validate(record)
    if record.team && record.group && record.team.group != record.group
      record.errors[:base] << "Team does not belong to group!"
    end
  end
end
