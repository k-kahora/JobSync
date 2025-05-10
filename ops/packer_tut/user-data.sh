#!/bin/bash -ex

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
EOS


# 1. Install Erlang
sudo -i -u ubuntu bash <<'EOS1'
set -eux
. $HOME/.asdf/asdf.sh
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git || true
asdf install erlang 27.3.3
EOS1

# 2. Install Elixir
sudo -i -u ubuntu bash <<'EOS2'
set -eux
. $HOME/.asdf/asdf.sh
asdf global erlang 27.3.3
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git || true
asdf install elixir 1.18.3-otp-27
asdf global elixir 1.18.3-otp-27
elixir --version
EOS2
