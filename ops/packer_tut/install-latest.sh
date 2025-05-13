#!/bin/bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

set -eu -o pipefail

# mix deps.get --only prod
#
# MIX_ENV=prod mix compile
#
# ## Compile assets
#
# MIX_ENV=prod mix assets.deploy
#
# ## Custom tasks (like DB migrations)
#
# MIX_ENV=prod mix ecto.migrate
#
#
sudo -i -u ubuntu bash <<EOS
set -eux

# Clone asdf
git clone -b prod --single-branch https://github.com/k-kahora/JobSync.git
cd JobSync
mix deps.get --prod


mix deps.get --only prod

MIX_ENV=prod mix compile

## Compile assets

MIX_ENV=prod mix assets.deploy

## Custom tasks (like DB migrations)
export DATABASE_URL=<fill in with database url>
export SECRET=<need secret here>

MIX_ENV=prod mix ecto.migrate
# Add asdf to .bashrc
EOS
