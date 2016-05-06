Feature: Test different kinds of users, make some admin, etc.

@new
Scenario: Sign in
  Given I sign in as an administrator named "Jim" with the email "jim@wherever.com"
  Then I should see "Successfully signed in"
  And I should see "Manage users"

  When I click "Sign out"
  Then I should see "Successfully signed out"
  Then I should see "Success"
  And I sign in as a non-administrator named "Joe" with the email "joe@wherever.com"
  And I should NOT see "Manage users"
