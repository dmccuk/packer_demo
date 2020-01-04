#!/bin/bash
set -x # see all output

# upgrade step
sudo apt update -yq # update the repos
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq # upgrade the OS
sudo apt install git nginx -yq # install git and nginx

# setup application
sudo mv /var/www/html /var/www/_html_orig
sudo git clone https://github.com/dmccuk/webapp1.git /var/www/html # clone out application in GIT
sudo systemctl enable nginx # enable nginx
