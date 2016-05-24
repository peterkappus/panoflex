Feature: Tag goals as belonging to the SDP. Then view them.

Scenario: Tag a few SDP goals
Given I create a goal named "Do something" with the owner email "jim@wherever.com" belonging to the group called "Digital"
When I sign in as an admin named "Jim" with the email "jim@wherever.com"
And I click on "View SDP goals"
Then I should NOT see "Do something"
And I should see "No goals have been designated"
When I click on "Vision"
And I click on "Do something"
And I click on "Edit goal"
And I tick the box "goal_sdp"
And I click on "Update Goal"
Then I click on "Vision"
And I click on "View SDP goals"
Then I should see "Do something"
