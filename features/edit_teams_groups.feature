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

Scenario: Make an update
  Given I import new goals
  And I click "Some big goal"
  And I click on "A sub-goal of the first goal"
  And I click on "Bitty Thing A"
  And I click on "Add a score"
  And I fill in "score_amount" with "22"
  And I fill in "score_reason" with "Because I said so."
  And I click "Create Score"
  Then I should see "22%"
  And I should see "Because I said"
  When I click on "Vision"
  Then I should see "11%"
