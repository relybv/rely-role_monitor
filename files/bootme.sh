#!/usr/bin/env bash
#
# This script installs puppet 3.x or 4.x and deploy the manifest using puppet apply -e "include role_monitor"
#
# Usage:
# Ubuntu / Debian: wget https://raw.githubusercontent.com/relybv/rely-role_monitor/master/files/bootme.sh; bash bootme.sh
#
# Red Hat / CentOS: curl https://raw.githubusercontent.com/relybv/rely-role_monitor/master/files/bootme.sh -o bootme.sh; bash bootme.sh
# Options: add 3 as parameter to install 4.x release

# default major version, comment to install puppet 3.x
PUPPETMAJORVERSION=4
export DEBIAN_FRONTEND=noninteractive
### Code start ###
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
   if [ "$1" = 3 ]; then
     PUPPETMAJOR=3
   else
     PUPPETMAJOR=4
  fi
else
  PUPPETMAJOR=$PUPPETMAJORVERSION
fi

if [ "$PUPPETMAJOR" = 3 ]; then
    MODULEDIR="/etc/puppet/modules/"
  else
    MODULEDIR="/etc/puppetlabs/code/modules/"
fi

# install dependencies
if which apt-get > /dev/null 2>&1; then
    apt-get update
    apt-get install apt-transport-https -y -q
  else
    echo "Using yum"
fi

apt-get install git bundler zlib1g-dev libaugeas-ruby -y -q || yum install -y git bundler zlib-devel

# get or update repo
if [ -d /root/role_monitor ]; then
  echo "Update repo"
  cd /root/role_monitor
  git pull
else
  echo "Cloning repo"
  git clone https://github.com/relybv/rely-role_monitor.git /root/role_monitor
  cd /root/role_monitor
fi

# install puppet
bash /root/role_monitor/files/bootstrap.sh $PUPPETMAJOR

# prepare bundle
echo "Installing gems"
/opt/puppetlabs/puppet/bin/gem install puppetlabs_spec_helper --no-rdoc --no-ri -q

# install dependencies from .fixtures
echo "Preparing modules"
/opt/puppetlabs/puppet/bin/rake spec_prep

# copy to puppet module location
cp -a /root/role_monitor/spec/fixtures/modules/* $MODULEDIR

echo "Run puppet apply"
/usr/local/bin/puppet apply -e "include role_monitor" --write-catalog-summary --log_level=err
