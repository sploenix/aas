#!/bin/bash

[ -z "$1" ] && {
  echo "No hostname/IP given .. EXIT"
  exit 0
}

KnownHostsFile=$HOME/.ssh/known_hosts

ssh-keygen -f $KnownHostsFile -R $1
