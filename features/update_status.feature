Feature: Update the status (score) of a goal

Scenario: Create a new goal, see its status, update the status and see it.
  Given I create a goal named "My fresh new goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  When I sign in as an admin named "Serena" with the email "serena@test.com"
  Then I should see "Not started"
  When I click on "My fresh new goal"
  And I click on "Make new progress update"
  #brittle but required for webrat radio selecting (clicking the label doesn't work)
  And I choose the radio button "radio-inline-on_track"
  #Leave reason blank and check that validation is working
  And I click "Save"
  Then I should see "can't be blank"
  #now fill it in...
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

Scenario: See goals in various states and click to view them.
  Given I create a new non-admin named "Serena" with the email "serena@test.com"
  Given I create a goal named "My fresh new goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  And I add a status of "on_track" and a narrative of "This goal is on track." to the goal called "My fresh new goal"
  Given I create a goal named "My off track goal" with the owner email "serena@test.com" belonging to the group called "Digital"
  And I add a status of "off_track" and a narrative of "This goal is OFF track." to the goal called "My off track goal"
  Given I create a goal named "My off track tech goal" with the owner email "serena@test.com" belonging to the group called "Technology"
  And I add a status of "off_track" and a narrative of "This goal is OFF track." to the goal called "My off track tech goal"
  And I sign in as a non-admin named "Gina" with the email "gina@test.com"
  When I visit the home page
  Then I should see "On track: 1" within "#digital"
  And I should see "Off track: 1" within "#digital"
  When I click on "On track: 1" within "#digital"
  Then I should see "My fresh new goal"
  And I should NOT see "My off track goal"
  When I visit the home page
  And I click on "Off track: 1"
  Then I should see "My off track goal"
  And I should NOT see "My fresh new goal"
