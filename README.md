# Jobsync

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# Based off of
## https://www.tealhq.com/tools/job-tracker?utm_campaign=na_ga_pm_intent&utm_medium=cpc&utm_source=google&utm_group=&gad_source=1&gclid=Cj0KCQjw782_BhDjARIsABTv_JBLo3MRdzSUu2zF296efL_deh4wp8th-cqY1T9MDmEjOiAu4UzFCuUaAs-9EALw_wcB

## Great component library
https://salad-storybook.fly.dev/welcome
# TODO
- [x] Landing Page Responsivness
- [ ] Use generated code to add job descriptions
- [ ] Upload a job description and extract the good stuff from it
- [ ] Do not need job list to be a live component
- [ ] Editing a entry duplicates, very weird
- [ ] Right now all external requests to AWS assume success, not good for prod, need asserts and tests 
- [ ] s3 key does not need to be shown to uploads, maybe in sql there is a way to map a key and then an additional string that is an alias of some sort
- [ ] Download button for all three file uploads


# Setting up AWS
aws configure sso
- set profile name to admin fo ex_aws to work
- aws configure export-credentials --profile admin --format env
can wrap the above in "eval $()"
The above will set all the env variables for you to use with ExAws

