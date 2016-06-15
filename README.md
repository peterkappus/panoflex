# Panoflex

### This is a goal-setting and tracking tool to show what GDS is working on and how well it's delivering.

## Status

The tool is currently used to show progress against linked goals and how those goals are represented within teams, and groups.

Due to privacy concerns and the need to accredit the host, the financial planning and people piece has been paused.

## Get involved! :)

This project is being developed within the Delivery Operations team at GDS which has no dedicated tech resource. We need help from people who understand:
- Back-end (Rails) development
- Front-end development
- The GOV.UK stack & suite of libraries, tools, and best practices.
- Web Ops
- User Research
- Service Design
- Visual Design
- Content Design


## Installing for develompent

### Mac OSX Setup

Install [homebrew](http://brew.sh) if not on your machine.
```
brew install postgres
git clone http://github.com/peterkappus/panoflex.git
cd panoflex
cp sample.env.txt .env
bundle
bundle exec rake db:setup

```
#### Authentication
This app uses Google Auth to authenticate users and create new accounts. Each time a user logs in his or her name and email address are used to create a new account in the system.

**NOTE:** The first user to log into the system will automatically be made into an admin. It is impossible to make yourself into a non-admin.

- Visit the [Google developer console](https://console.developers.google.com)
- Create a new project (Name it whatever you like)
- Click "Credentials" (on the left-hand nav)
- Click on "OAuth consent screen"
- Create & save a new product
- Click "Create Credentials"
- Select "Web application"
- Provide a name (whatever you like)
- Add your local callback URI (e.g. http://localhost:5000/auth/google_oauth2/callback) to the Authorised Redirect URIs section
- Click Save (TWICE)
- Copy our Client ID and Secret to your `.env` file

To start the server use
`$ heroku local`

It also has a `Procfile` which you probably won't need to touch.


### Deploying to heroku

 - Set up a heroku account (or use an existing one)
 - Create a new app
 - Decide if you want to point it at your own fork of the app, a particular release, or branch, or the HEAD. For production instances, it's recommended you point it to the latest stable release.
 - Go to the "Settings" tab
 - click "reveal config vars"
 - Create new keys for GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, and any other config params set in your `.env` file


## Data backups
 TIP: Need to backup your heroku database before deploying?

 ```
 $ heroku pg:backups capture --app APPNAME
 ```

 Want daily backups?
 ` heroku pg:backups schedule DATABASE_URL --at '02:00 Europe/London' --app APPNAME`

 You can save it locally if you want:

 ```
 $ curl -o latest.dump `heroku pg:backups public-url --app APPNAME`
 ```

  Read more about [postgres backups](https://devcenter.heroku.com/articles/heroku-postgres-backups)  including how to restore.

## Testing

This app attempts to use BDD principles as much as possible. It still needs proper unit tests but in the meantime, all new functionality should be covered by integration tests. To make cucumber run for this app, here's what I have to do (after installing all the gems, etc).

### Running cucumber
`$ bundle exec cucumber`

Or only run @wip (work in progress) tests:

`$ bundle exec cucumber:wip`


## The Backlog

### Do next
- Tree view
- Ability to add comments to a goal
- Email alerts when people down-stream add updates
- "Nudge" a goal
- "Like" an update
- Include updates at all levels in export
- Disallow entering a deadline before the start_date (use validates_date gem?)
- Version control to see when/why/how/and by whom a goal change was made.
- Ability to view old versions of goals
- Add a RAG status based on % complete vs time remaining
- Rename "deadline" to "end_date" everywhere
- Browse goals by due-date quarter (how will this affect scoring?)
- Add unit tests using [Factory Girl & Rspec](https://semaphoreci.com/community/tutorials/setting-up-the-bdd-stack-on-a-new-rails-4-application)
- Start using the GOV.UK components instead of reinventing the wheel
- Ween ourselves off of bootstrap and just use the standard GOV.UK CSS.

### DONE (AKA "What's new?")
- View all progress updates for a goal
- Add name of person who created score in export (and email)
- Allow an arbitrary number of levels for export (export contains all goals)
- Search for goals using free text
- Search based on person name
- Ability to create teams & groups
- Ability to delete teams & groups (only when no goals are assigned)
- Pretty doughnut graphs (via Google charts) showing distribution of delivery status within a group/team/person/SDP/etc
- Click a name and see all goals owned by that person
- Capture monthly (or weekly?) local backups
- Ability to show only SDP goals
- Hide scores & scoring functionality (make scores optional)
- When reporting, add requirement to select a status:, Not Started (default), On-track, Off-track, Significant Delay/Issue, Delivered- Implement new "box-based" UI (see Lucy F's mockup)
- Add ability to report progress at all levels.
- Add ability to flag a goal as belonging to the SDP (+ tests)
- Assign "owners" to goals who can update progress.
- Allow cabinetoffice.gov.uk email addresses to login
- Don't allow people to assign goals to a team and group which don't match (e.g. don't select GOV.UK and Data)
- Change goal edit form to disallow assigning a time if goal has sub-goals. Explain that team assignment will be determined by sub-goal teams.
- Ability for Administrators to promote/revoke admin status for existing users.
- Exporting goals now includes all updates/scores.
- Hide date fields when editing a goal with sub-goals (and explain why)
- Sort sub-goals by start date
- redirect to parent goal when successfully creating sub-goal (based on user research)
- 25% performance improvement by saving derived scores in Goal model (BEFORE: Expand_all w/ 406 goals took ~ 14seconds to load & render AFTER: 10.46seconds
- Links are blue again so it's obvious you can click 'em
- Refactor sub_goals and clean up "expand all" rendering using rows & columns
- Determine start/end dates by looking at sub-goals
- Created a simple /dashboard resource to show some useful stats...
- Add user to goals and scores so you can see who created/last-modified a goal or score.
- Add start/end dates to goals (and include in form)
- Add links for admins to edit team/group info
- Setup Cucumber and Capybara and write some basic tests
- use "slugged" names for team/group URLs (e.g. groups/operations vs groups/4)
- show teams for parent goals where all children have the same team
- Make an "about" page explaining the thing and that its a pre-alpha proof of concept
- Fix the header so the proposition links don't disappear on mobile
- Add Group & Team goals pages & links
- Add GOV.UK page layout template
- Paginate full role listing
- Associate roles to functions (initially by function_name) w/ error reporting

### Someday/Maybe
- Clickable hashtags in goal text?
- Make names click-able to search for all roles using that person
- Search for role by type
- Add non-people costs (EPIC)
- Filter to show vacant roles per team (by month)
