Feature: Edit information about teams and groups

Scenario: Edit Group names
  Given I import new goals
  When I click on "Groups and Teams"
  And I click on "Digital"
  And I click on "Edit Group"
  Then I should see "Editing Group"
  When I fill in "group_budget_in_millions" with "3.14"
  And I click "Update Group"
  Then I should see "3.1m"

  When I click on "Edit Group"
  And I fill in "group_headcount" with "99"
  And I click "Update Group"
  Then I should see "99"

Scenario: Create a new group
  Given I sign in as an admin named "Lisa" with the email "lisa@blah.com"
  When I click on "Groups and Teams"
  And I click on "Create a new group"
  And I fill in "group[name]" with "My cool new group"
  And I click "Create Group"

Scenario: Don't see "new group" link as a non-admin
  Given I sign in as a non-admin named "Lisa" with the email "lisa@blah.com"
  When I click on "Groups and Teams"
  Then I should NOT see "Create a new group"
