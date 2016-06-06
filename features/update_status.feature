Feature: Update the status of a goal

Scenario: Create a new goal, see its status, update the status and see it.
  Given I create a goal named "My fresh new goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  When I sign in as an admin named "Serena" with the email "serena@test.com"
  Then I should see "Not started"
  When I click on "My fresh new goal"
  And I click on "Make new update"
  #brittle but required for webrat radio selecting (clicking the label doesn't work)
  And I choose the radio button "radio-inline-on_track"
  And I fill in "score[reason]" with "This is why I think things are on track."
  And I click "Save"
  Then I should see "On track"
  And I should see "This is why"
