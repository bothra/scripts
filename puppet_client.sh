#!/usr/bin/env bash
# This bootstraps Puppet on CentOS 7.x

set -e

REPO_URL="https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which puppet > /dev/null 2>&1; then
  echo "Puppet is already installed."
  exit 0
fi

# Install wget
yum -y install wget >/dev/null

# Install puppet labs repo
echo "Configuring PuppetLabs repo..."
repo_path=$(mktemp)
wget --output-document="${repo_path}" "${REPO_URL}" 2>/dev/null
rpm -i "${repo_path}" >/dev/null

# Install Puppet...
echo "Installing puppet..."
yum install -y puppet  >/dev/null

echo "adding /opt/puppetabs/bin to PATH..."
export PATH=$PATH:/opt/puppetlabs/bin/

echo "puppet installed!"
