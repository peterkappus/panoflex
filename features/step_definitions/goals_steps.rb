When(/^I create a sub\-goal called "([^"]*)"$/) do |goal_text|
  steps %Q{
    And I click on "Create sub-goal"
    When I fill in "goal_name" with "#{goal_text}"
		And I click "Create Goal"
  }
end

When(/^I create a new goal called "([^"]*)"$/) do |goal_text|
  steps %Q{
    And I click on "New Goal"
    And I fill in "goal_name" with "#{goal_text}"
    And I click "Create Goal"
  }
end


When(/^I import new goals$/) do
  #Given(/^I am signed in as an administrator named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  steps %Q{
   And I am signed in as an administrator named \"Admin Person\" with the email \"admin@domain.gov.uk\"
  }
  attach_file("file","#{ENV['RAILS_ROOT']}/okr_sample_import.csv")
  find_button("Import").click
end
