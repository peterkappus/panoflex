Feature: Edit information about teams and groups

#not doing this anymore...
@removed
Scenario: Edit group names
  #Given I import new goals
  #And I click on "Edit this group" within "#digital"
  #Then I should see "Editing Group"
  #When I fill in "group_budget_in_millions" with "3.14"
  #And I click "Update Group"
  #Then I should see "3.1m"
  #When I click on "Edit this group"
  #And I fill in "group_headcount" with "99"
  #And I click "Update Group"
  #Then I should see "99"

Scenario: Create a new group, then delete it
  Given I sign in as an admin named "Lisa" with the email "lisa@blah.com"
  And I click on "Create a new group"
  And I fill in "group[name]" with "My cool new group"
  And I click "Create Group"
  Then I should see "cool new group"
  When I click "Edit this group"
  #webrat shouldn't see the confirmation popup
  And I click "Delete this group"
  Then I should see "destroyed"

Scenario: Don't see "new group" link as a non-admin
  Given I sign in as a non-admin named "Lisa" with the email "lisa@blah.com"
  Then I should NOT see "Create a new group"
  Scenario: Don't see "new group" link as a non-admin
