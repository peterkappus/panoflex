Feature: Update the status (score) of a goal

Scenario: Create a new goal, see its status, update the status and see it.
  Given I create a goal named "My fresh new goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  When I sign in as an admin named "Serena" with the email "serena@test.com"
  Then I should see "Not started"
  When I click on "My fresh new goal"
  And I click on "Make new progress update"
  #brittle but required for webrat radio selecting (clicking the label doesn't work)
  And I choose the radio button "radio-inline-on_track"
  And I fill in "score[reason]" with "Everything is going swimmingly."
  And I click "Save"
  Then I should see "On track"
  And I should see "swimmingly"
  When I visit "/goals/show_export"
  Then I should see "swimmingly"
  And I should see "Serena"
  And I should see today's date in the format YYYY-MM-DD

Scenario: View all progress updates
  Given I create a new non-admin named "Serena" with the email "serena@test.com"
  And I create a goal named "My first goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  When I sign in using "serena@test.com"
  And I visit the goal called "My first goal"
  Then I should see "Not started"
  When I add a status of "off_track" and a narrative of "This is my initial progress report." to the goal called "My first goal"
  And I visit the goal called "My first goal"
  Then I should see "Off track"
  And I should see "initial progress"
  #now add another status update
  When I add a status of "on_track" and a narrative of "This is my second progress report." to the goal called "My first goal"
  And I visit the goal called "My first goal"
  Then I should see "On track"
  And I should see "second progress report"
  And I should NOT see "initial progress report"
  When I click on "View all progress updates"
  #now see both...
  Then I should see "initial progress report"
  And I should see "second progress report"
  And I should see "Download status updates"
  And I should see "Download goals"
  When I visit "/scores/show_export"
  Then I should see "initial progress"
  And I should see "second progress"
  And I should see "My first goal"
