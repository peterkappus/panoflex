Given(/^I sign in as an admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.find_by(email: email) || User.create!(:name=>name,:email=>email, :admin=>true)
  step "I sign in using the email \"#{email}\""
end

When(/^I sign in as a non\-admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.find_by(email: email) || User.create!(:name=>name,:email=>email, :admin=>false)
  step "I sign in using the email \"#{email}\""
end


When(/^I create a new non\-admin named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.create!(:name=>name,:email=>email, :admin=>false)
end

When(/^I sign in using the email "([^"]*)"$/) do |email|
  visit signin_path(email: email)
end
