Feature: Edit information about teams and groups

Scenario: Make some updates
  Given I import new goals
  When I click "Some big goal"
  And I click on "A sub-goal of the first goal"
  And I click on "Bitty Thing A"
  And I click on "Report Progress"
  And I fill in "score_amount" with "22"
  And I fill in "score_reason" with "Because I said so."
  And I click "Create Score"
  Then I should see "22%"
  And I should see "Because I said"

  When I click on "Vision"
  Then I should see "11%"

  When I click "Some big goal"
  And I click on "A sub-goal of the first goal"
  And I click on "Bitty Thing B"
  And I click on "Report Progress"
  And I fill in "score_amount" with "5"
  And I fill in "score_reason" with "A very good reason."
  And I click "Create Score"
  Then I should see "5%"
  When I click on "Vision"
  Then I should see "13%"
