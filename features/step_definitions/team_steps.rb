Given(/^I visit a team page "([^"]*)"$/) do |name|
    group = Group.create!(name: "The Who")
    team = Team.find_or_create_by!(name: name, group: group)
    visit team_path(team)
end
