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
