When(/^I create a sub\-goal called "([^"]*)"$/) do |goal_text|
  steps %Q{
    And I click on "Create sub-goal"
    When I fill in "goal_name" with "#{goal_text}"
		And I click "Create Goal"
  }
end

Given(/^I create a goal named "([^"]*)" with the owner email "([^"]*)" belonging to the group called "([^"]*)"$/) do |goal_name, email, group_name|
  Goal.create!(name: goal_name, owner: User.find_by(email:email), group: Group.find_or_create_by!(name: group_name), start_date: Date.today, deadline: Date.today+3.month)
end

#click a "create a new goal" link within an ID
When(/^I create a new goal called "([^"]*)" within "([^"]*)"$/) do |goal_text, div_id|
  steps %Q{
    And I click on "Create a new goal" within "#{div_id}"
    And I fill in "goal_name" with "#{goal_text}"
    And I click "Create Goal"
  }
end

When(/^I visit the goal called "([^"]*)"$/) do |name|
  g = Goal.find_by(name: name)
  visit goal_path(g)
end

Given(/^I create a goal named "([^"]*)" with the owner email "([^"]*)" belonging to the group called "([^"]*)" with a deadline of "([^"]*)"$/) do |goal_name, email, group_name, deadline|
  Goal.create!(name: goal_name, owner: User.find_by(email:email), group: Group.find_or_create_by!(name: group_name), start_date: Date.today, deadline: Date.parse(deadline))
end

#NOTE: finds the first goal with the matching name.
Given(/^I create a sub\-goal of "([^"]*)" called "([^"]*)" with a deadline of "([^"]*)"$/) do |parent_name, goal_name, deadline|
  parent = Goal.find_by(name: parent_name)
  Goal.create!(parent: parent, name: goal_name, owner: parent.owner, group: parent.group, start_date: parent.start_date, deadline: Date.parse(deadline))
end

#NOTE! Assumes names are unique.... be careful. :)
When(/^I change the deadline of the first goal called "([^"]*)" to be "([^"]*)"$/) do |name, deadline|
  Goal.find_by(name: name).update!(deadline: Date.parse(deadline))
end

When(/^I should see today's date in the format YYYY-MM-DD$/) do
  step "I should see \"#{Time.now.strftime("%Y-%m-%d")}\""
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


When(/^I add a status of "([^"]*)" and a narrative of "([^"]*)" to the goal called "([^"]*)"$/) do |status_sym, narrative, goal_name|
  g = Goal.find_by(name: goal_name)
  g.scores << Score.create!(status: status_sym.to_sym, reason: narrative, user: User.all.sample, goal: g)
end
