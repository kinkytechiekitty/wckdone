#!/bin/sh

#Build essentials
sudo apt-get update -y	
sudo apt-get install -y build-essential tmux emacs-nox

# Docker
sudo apt-get -yff install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
~/.rbenv/bin/rbenv init
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
rbenv install 2.6.2
rbenv global 2.6.2

# Others
sudo apt-get install -yff redis
sudo apt-get install -yff mysql-server libmysqlclient-dev
sudo apt-get install -yff imagemagick

# Mysql setup
sudo mysql -e "CREATE USER 'wckdone'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL ON *.* TO 'wckdone'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Shell setup
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install rerun gem
gem install rerun
