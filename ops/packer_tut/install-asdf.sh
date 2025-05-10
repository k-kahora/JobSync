#!/bin/bash -euxo pipefail

# 1) Install system packages
sudo apt install -y \
  build-essential autoconf automake libncurses5-dev unzip \
  libssl-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev \
  git curl

# 2) Setup asdf + Erlang + Elixir as ubuntu user
sudo -i -u ubuntu bash <<EOS
set -eux

# Clone asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0

# Add asdf to .bashrc
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
echo 'export KERL_BUILD_DOCS=yes' >> ~/.bashrc

# Load asdf immediately
. $HOME/.asdf/asdf.sh

export KERL_INSTALL_USE_PREBUILT=1

# Add and install Erlang
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git || true
asdf install erlang 27.3.3
asdf global erlang 27.3.3

# Add and install Elixir
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git || true
asdf install elixir 1.18.3-otp-27
asdf global elixir 1.18.3-otp-27
EOS
