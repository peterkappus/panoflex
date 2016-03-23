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

This app is setup to run on Heroku. To run it locally, you MUST create a .env file like so:

```
BASIC_AUTH_USERNAME=whatever
BASIC_AUTH_PASSWORD=somepassword
```

To start the server use
`$ heroku local`

It also has a `Procfile` which you probably won't need to touch.

## TODO

### Next
- Setup Cucumber and Capybara and write some tests
- Make an "about" page explaining the thing and that its a pre-alpha proof of concept
- Browse goals by due-date quarter
- Fix the header so the proposition links don't disappear on mobile
- Start using the GOV.UK components instead of reinventing the wheel
- Ween ourselves off of bootstrap and just use the standard GOV.UK CSS.

### Someday
- Search for role by name
- Make names click-able to search for all roles using that person
- Search for role by type
- Add non-people costs (EPIC)
- Make short_names for each GDS function unique (in DB and model)
- slugify functions by short name (e.g. /functions/dcp vs /funcitons/4)
- Filter to show vacant roles per Function (by month)
- Split allocation into separate table away from roles Stop using "hard-coded" months :(

## DONE
- Add Group & Team goals pages & links
- Add GOV.UK page layout template
- Paginate full role listing
- Associate roles to functions (initially by function_name) w/ error reporting
