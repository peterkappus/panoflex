Feature: Edit information about teams and groups

Scenario: Edit Group names
  Given I am signed in
  And I import new goals
  When I click on "Groups and Teams"
  Then I should see "Digital"
  When I click on "Digital"
  And I click on "Edit Group"
  Then I should see "Editing Group"
  And I should see "Digital"
