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


-- super helpful
https://typeclasses.com/nixos-on-aws
https://curiosum.com/blog/packaging-elixir-application-with-nix
# PLAN
Run this flake as a dev shell in a nixos environment,
deploy that
work on making a derivation in the meantime
you have sunk too much time into this

# For deploying you also need to set the following to test database connection in dev environment
  ssl: true,
  ssl_opts: [verify: :verify_none]

# Notes 
Need to generate secrets first as well as DATABASE_URL
check origin needs to be set as well in config.exs
check_origin: ["http://34.207.84.96:4000"], ip adress of the EC2 instance
deployment script

## Initial setup

mix deps.get --only prod

MIX_ENV=prod mix compile

## Compile assets

MIX_ENV=prod mix assets.deploy

## Custom tasks (like DB migrations)

MIX_ENV=prod mix ecto.migrate

## Finally run the server

PORT=4001 MIX_ENV=prod mix phx.server

I have a user data set up, I should have it clone

# 
mix phx.gen.secret
REALLY_LONG_SECRET

export SECRET_KEY_BASE=REALLY_LONG_SECRET

export DATABASE_URL=ecto://USER:PASS@HOST/database
# Production I need a terraform script to set up my ec2 asg load balancers even me smtp email, I also need a ci/cd pipeline to automate the deployment of this that is the goal, so far I have manually got a set up working
- [ ] Terraform VPC module setup
- [x] Single ec2 with a rds instance 
- [x] CI/CD to automattically deploy to this instance
- [ ] Terraform works with using the latest AMI however i want the setup to work with a way that a user can use just run terraform apply and boom everything is up adn running, also i ened hella good docs for this setup and a really banging blog post as well, by EOD today I want this working fully with CI/CD and then just running terraform apply
- [ ] Also rn, I need to manually change check_origin, or find some work around
- [ ] Also need so use sed or something to change the DATABASE_URL, right now the database url is hardcoded and there is no way around this unfortnately no easy way at least


# Systemd service
[Unit]
Description=Jobsync App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/JobSync
ExecStart=/home/ubuntu/JobSync/_build/prod/rel/jobsync/bin/jobsync start
ExecStop=/home/ubuntu/JobSync/_build/prod/rel/jobsync/bin/jobsync stop
Restart=on-failure
Environment=HOME=/home/ubuntu
Environment=LANG=en_US.UTF-8
Environment=MIX_ENV=prod
Environment=SECRET_KEY_BASE=nUwMp5BTypO/A22d5WqGXCkQCdsPmYchAGDXWcunIGxZJxcjqaohmg2ewKyJawiJ
Environment=PORT=4000
Environment=DATABASE_URL=ecto://postgres:postgres@test-db.cuvoig8w0zge.us-east-1.rds.amazonaws.com/jobsync

[Install]
WantedBy=multi-user.target

# Trigger actions
