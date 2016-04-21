# Panoflex

This is a loosely connected set of tracking and reporting tools that facilitate running a large organisation like GDS. E.g. roles, vacancies, communities, non-people costs, teams, groups, and goals.

## Status

The tool is currently used to show progress against linked goals and how those goals are represented within teams, and groups.

Due to privacy concerns and the need to accredit the host, the financial planning and people piece has been paused.

OKR data is currently held in a Google Sheet  and periodically imported. This is currently a safer/easier place to keep the data and allow GDS teams to collaborate. As this tool gets more mature, we should maintain the data only in the tool and move away from Google Sheets.

## Please get involved! :)

This project is being developed within the Delivery Operations team at GDS which has no dedicated tech resource. We need help from people who understand:
- Rails Development
- The GOV.UK stack & suite of libraries, tools, and best practices.
- Web Ops
- User Research
- Visual Design
- Content Design


## Setup

This app is setup to run on Heroku. To run it locally, you *MUST* copy the `sample.env.txt` file to `.env` and customise it for environment(s).

To start the server use
`$ heroku local`

It also has a `Procfile` which you probably won't need to touch.

### Data loading

You'll probably want to import some goals from a spreadsheet that looks like this (TODO: include link). This will create the teams and groups and some initial goals. There's currently no easy way to access the group/team creation UI.

## Testing

TODO: write unit tests. Meanwhile, use Cucumber to do end-to-end testing. To make cucumber run for this app, here's what I have to do (after installing all the gems, etc).

### Running cucumber
`$ bundle exec cucumber`

Remember, you can tag tests and decide which ones to run:
E.g. exclude tests tagged with @wip:

`$ cucumber --tags ~@wip`

Or only run @new tests:

`$ cucumber --tags @new`


## The Backlog

### DONE (AKA "What's new?")
- Links are blue again so it's obvious you can click 'em
- Refactor sub_goals so that the "expand all" option looks better
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

### Next Up
- Improve performance by saving derived values in the model (Add columns for "original" values for team, group, start/end dates)
- Rename "deadline" to "end_date" everywhere
- Ability to add comments to a goal
- Add a RAG status based on % complete vs time remaining
- Browse goals by due-date quarter
- Search for goals using free text
- Add unit tests using [Factory Girl & Rspec](https://semaphoreci.com/community/tutorials/setting-up-the-bdd-stack-on-a-new-rails-4-application)
- Start using the GOV.UK components instead of reinventing the wheel
- Ween ourselves off of bootstrap and just use the standard GOV.UK CSS.

### Someday/Maybe
- Search for role by name
- Searchable hashtags in goal text?
- Make names click-able to search for all roles using that person
- Search for role by type
- Add non-people costs (EPIC)
- Make short_names for each GDS function unique (in DB and model)
- Filter to show vacant roles per Function (by month)
- Split allocation into separate table away from roles Stop using "hard-coded" months :(
