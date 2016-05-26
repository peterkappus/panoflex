When(/^I create a sub\-goal called "([^"]*)"$/) do |goal_text|
  steps %Q{
    And I click on "Create sub-goal"
    When I fill in "goal_name" with "#{goal_text}"
		And I click "Create Goal"
  }
end

Given(/^I create a goal named "([^"]*)" with the owner email "([^"]*)" belonging to the group called "([^"]*)"$/) do |goal_name, email, group_name|
  Goal.create!(name: goal_name, owner: User.find_by(email:email), group: Group.find_or_create_by!(name: group_name), start_date: Date.today, deadline: Date.today+1.month)
end

When(/^I create a new goal called "([^"]*)"$/) do |goal_text|
  steps %Q{
    And I click on "Create a new goal"
    And I fill in "goal_name" with "#{goal_text}"
    And I click "Create Goal"
  }
end

When(/^I create a group called "([^"]*)"$/) do |group_name|
  Group.create!(name: group_name)
end

When(/^I create a team called "([^"]*)" within the group called "([^"]*)"$/) do |team_name, group_name|
  group = Group.find_or_create_by!(name: group_name)
  Team.find_or_create_by!(name: team_name, group: group)
end

When(/^I import new goals$/) do
  #Given(/^I am signed in as an admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  steps %Q{
   And I sign in as an admin named \"Peter Kappus\" with the email \"admin@domain.gov.uk\"
  }
  attach_file("file","#{ENV['RAILS_ROOT']}/okr_sample_import.csv")
  find_button("Import").click
end
