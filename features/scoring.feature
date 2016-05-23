Feature: Edit information about teams and groups

Scenario: Make some updates, check the export contains the score(s)
  Given I import new goals
  When I click "Some big goal"
  And I click on "A sub-goal of the first goal"
  And I click on "Bitty Thing A"
  And I click on "Report progress"
  #hiding scores for now
  Then I should NOT see "Amount"
  #And I fill in "score_amount" with "22"
  And I fill in "score_reason" with "My reason"
  And I click "Create Score"
  #We've now hidden completion percentages for now..
  Then I should NOT see "22%"
  Then I should see "My reason"
  # OBSOLETE. We're not doing score roll-up anymore, but leaving this in case we need to bring it back.
  #  When I click on "Vision"
  #  Then I should see "11%"
  #  When I click "Some big goal"
  #  And I click on "A sub-goal of the first goal"
  #  And I click on "Bitty Thing B"
  #  And I click on "B1"
  #  And I click on "Report progress"
  #  And I fill in "score_amount" with "5"
  #  And I fill in "score_reason" with "A very good reason."
  #  And I click "Create Score"
  #  Then I should see "5%"
  #  When I click on "Bitty Thing B"
  #  Then I should see "3%"
  #  When I click on "Vision"
  #  #3 + 22 / 2
  #  Then I should see "13%"
  #  When I visit "/goals/show_export"
  #  Then I should see "5"
  #  And I should see "A very good reason."
