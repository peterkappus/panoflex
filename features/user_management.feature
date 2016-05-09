Feature: Test different kinds of users, make some admin, etc.

@new
Scenario: Sign in
  Given I sign in as an administrator named "Jim" with the email "jim@wherever.com"
  Then I should see "Successfully signed in"
  And I should see "Manage users"

  When I click "Sign out" within "nav"
  Then I should see "Successfully signed out"
  Then I should see "Success"
  And I sign in as a non-administrator named "Joe" with the email "joe@wherever.com"
  Then I should NOT see "Manage users"

@new
Scenario: Get redirected when trying to access admin only funcitonality
  And I sign in as a non-administrator named "Joe" with the email "joe@wherever.com"
  And I visit "/users"
  Then I should see "requires admin"

@new
Scenario: Make someone an administrator
  Given I sign in as an administrator named "Jim" with the email "jim@wherever.com"
  When I create a new non-admin user named "Dave" with the email "dave@test.com"
  And I click on "Manage users"
  Then I should see "Dave"
  And I should see "dave@test.com"
