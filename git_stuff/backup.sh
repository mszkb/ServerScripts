#!/bin/bash

# Use this script for automating git commit and push stuff for backup purpose
# It will send a message to your Telegram if it was successfull/failed
#
# Install telegram-send and configure the bot
# See: http://www.linux-magazine.com/Online/Blogs/Productivity-Sauce/Push-Messages-from-the-Command-Line-to-Telegram
#
# Installation:
#  sudo apt install python
#  sudo pip3 install telegram-send
#  telegram-send --configure
#
# Care:
# If u use "sudo telegram-send --configure" it will be configured for the superuser
# U need to configure this software with the user u want to use it
#

### VARIABLES START

DIR=/var/customers/webs/superkawaii/wiki	# Directory where the git repo lies
DATE="Backup $(date +%d.%m.%Y)"			# Todays Date

### VARIABLES END


# change directory, do prevent git stuff from root folder (cronjob and stuff)
cd $DIR


# Process messages from git
push_git () {

  GIT_PUSH_MSG=$(git push -n)

  echo $GIT_PUSH_MSG
  if $GIT_PUSH_MSG | grep 'Could not read from remote repository'; then
    echo "Git Problem, maybe remote offline?"
    telegram-send "Git Problem, maybe remote offline?"
    exit 1
  fi

  git push origin master
  echo "git push was successful!"
  telegram-send "$DATE auf gitlab"
}


# Standard commit message
commit_git() {
  git add -A
  git commit -m "$DATE"
}


# Push backup first before checking changes
if git status | grep 'Your branch is ahead of'; then
  echo "no changes made"
  push_git
  exit 0
fi

# If no changes made, no push needed
if git diff-index --quiet HEAD --; then
  echo "everythings up to date"
  telegram-send "$DATE - no backup needed"
  exit 0
fi


# Changes made, do git stuff
commit_git
push_git


