# Panoflex

This is a loosely connected set of tracking and reporting tools that facilitate running a large organisation like GDS. E.g. roles, vacancies, communities, non-people costs, teams, groups, and goals.

## Status

The tool is currently used to show progress against linked goals and how those goals are represented within teams, and groups.

Due to privacy concerns and the need to accredit the host, the financial planning and people piece has been paused.

OKR data is currently held in a Google Sheet  and periodically imported. This is currently a safter/easier place to keep the data and allow GDS teams to collaborate. As this tool gets more mature, we should maintain the data only in the tool and move away from Google Sheets.

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

## Testing

TODO: write unit tests. Meanwhile, use Cucumber to do end-to-end testing. To make cucumber run for this app, here's what I have to do (after installing all the gems, etc).

### First Time:
You'll need to seed the test database by running
`bundle exec rake db:seed RAILS_ENV=test`
Otherwise, you'll get errors since there won't be any groups.

### Running cucumber
`$ bundle exec cucumber BASIC_AUTH_USERNAME=x BASIC_AUTH_PASSWORD=x`

You MUST pass in a username & password in the environment so rails can set up the basic auth. Use x/x for the username/pass since that's what the step definition uses when attempting to login. Don't say I didn't warn ya.

Remember, you can tag tests and decide which ones to run:
E.g. exclude tests tagged with @wip:

`$ cucumber --tags ~@wip`

Or only run @new tests:

`$ cucumber --tags @new`


## TODO

### Next
- Browse goals by due-date quarter
- Add unit tests using [Factory Girl & Rspec](https://semaphoreci.com/community/tutorials/setting-up-the-bdd-stack-on-a-new-rails-4-application)
- Start using the GOV.UK components instead of reinventing the wheel
- Ween ourselves off of bootstrap and just use the standard GOV.UK CSS.

### Someday
- Search for role by name
- Make names click-able to search for all roles using that person
- Search for role by type
- Add non-people costs (EPIC)
- Make short_names for each GDS function unique (in DB and model)
- Filter to show vacant roles per Function (by month)
- Split allocation into separate table away from roles Stop using "hard-coded" months :(

### DONE (What's new?)
- use "slugged" names for team/group URLs (e.g. groups/operations vs groups/4)
- show teams for parent goals where all children have the same team
- Make an "about" page explaining the thing and that its a pre-alpha proof of concept
- Fix the header so the proposition links don't disappear on mobile
- Setup Cucumber and Capybara and write some basic tests
- Add Group & Team goals pages & links
- Add GOV.UK page layout template
- Paginate full role listing
- Associate roles to functions (initially by function_name) w/ error reporting
