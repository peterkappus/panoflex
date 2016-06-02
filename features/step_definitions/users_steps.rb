Given(/^I sign in as an admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.find_or_create_by!(:name=>name,:email=>email, :admin=>true)
  step "I sign in using the email \"#{email}\""
end

When(/^I sign in as a non\-admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.find_or_create_by!(:name=>name,:email=>email, :admin=>false)
  step "I sign in using the email \"#{email}\""
end

When(/^I click on the checkbox next to "([^"]*)"$/) do |email|
  #the checkboxes have CSS id based on the user id (#user{id})
  user_id = User.find_by(email: email).id
  find('#user' + user_id.to_s).click
end

When(/^I create a new non\-admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.create!(:name=>name,:email=>email, :admin=>false)
end

When(/^I sign in (?:with|using)(?: the email)? "([^"]*)"$/) do |email|
  visit signin_path(email: email)
end
