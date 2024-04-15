#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

# Create `deployer` user
adduser --disabled-password deployer < /dev/null
mkdir -p /home/deployer/.ssh
cp /root/.ssh/authorized_keys /home/deployer/.ssh
chown -R deployer:deployer /home/deployer/.ssh
chmod 600 /home/deployer/.ssh/authorized_keys

# TODO: This was to avoid errors during update that looked like
# GPG error: http://security.ubuntu.com/ubuntu jammy-security InRelease: At least one invalid signature was encountered.

apt -y update --allow-insecure-repositories

# Install and configure sshd
apt-get -y install openssh-server git
echo "Port 22" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
mkdir /var/run/sshd
chmod 0755 /var/run/sshd
