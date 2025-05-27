#!/bin/bash
set -euxo pipefail

DATABASE_URL="ecto://postgres:postgres@postgres-delete.c1iooq4k4dt8.us-west-2.rds.amazonaws.com/jobsync"

# Run as ubuntu with clean variable escaping
sudo -u ubuntu bash -l -c '
  set -eux

  . ~/.asdf/asdf.sh
  . ~/.asdf/completions/asdf.bash

  cd ~
  git clone -b development --single-branch https://github.com/k-kahora/JobSync.git
  cd JobSync

  export DATABASE_URL="'"$DATABASE_URL"'"

  mix deps.get 
  mix deps.get --only prod
  MIX_ENV=prod mix compile

  SECRET_KEY_BASE=$(mix phx.gen.secret | tail -n 1)
  echo "$SECRET_KEY_BASE" > /tmp/secret_key_base

  export SECRET_KEY_BASE="$SECRET_KEY_BASE"

  MIX_ENV=prod mix assets.deploy
  MIX_ENV=prod mix ecto.migrate
  mix phx.gen.release
  MIX_ENV=prod mix release
'

# Pull the secret from inside the user shell
SECRET_KEY_BASE=$(sudo cat /tmp/secret_key_base)
echo "Generated SECRET_KEY_BASE: $SECRET_KEY_BASE"

# Create the systemd unit
cat <<EOF | sudo tee /etc/systemd/system/jobsync.service
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
Environment=SECRET_KEY_BASE=${SECRET_KEY_BASE}
Environment=PORT=4000
Environment=DATABASE_URL=<REPLACEME>

[Install]
WantedBy=multi-user.target
EOF

# sudo systemctl daemon-reload
# sudo systemctl enable jobsync
