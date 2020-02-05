#!/bin/bash
set -x # see all output

# upgrade step
sudo apt update -yq # update the repos
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq # upgrade the OS
sudo apt install wget curl git python3-minimal -yq
