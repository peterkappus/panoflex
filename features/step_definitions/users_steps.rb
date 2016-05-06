Given(/^I sign in as an administrator named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.create(:name=>name,:email=>email, :admin=>true)
  visit signin_path(email:user.email)
end

When(/^I sign in as a non\-administrator named "([^"]*)" with the email "([^"]*)"$/) do |name, email|
  user = User.create(:name=>name,:email=>email, :admin=>false)
  visit signin_path(email:user.email)
end
