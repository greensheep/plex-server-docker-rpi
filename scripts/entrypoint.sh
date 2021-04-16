#!/bin/bash

set -e

PLEX_USER_ID=$(id -u $PLEX_USER_NAME)
PLEX_GROUP_ID=$(id -g $PLEX_USER_NAME)

echo "=> Plex user id: $PLEX_USER_ID"

# If a user id was supplied, and this doesn't match the plex user, update it
if [ ! -z "${SET_PLEX_UID}" ]; then
  if [ ! "$PLEX_USER_ID" -eq "${SET_PLEX_UID}" ]; then

    # Updating the user id is causing the following error:
    # usermod: Failed to change ownership of the home directory
    # To get round this, create a temporary home dir, update the
    # user id, then set it back
    TEMP_HOME_DIR=/tmp/plexhomedir
    mkdir $TEMP_HOME_DIR
    usermod -d $TEMP_HOME_DIR $PLEX_USER_NAME

    # Update user id
    usermod -o -u "${SET_PLEX_UID}" $PLEX_USER_NAME
    echo "=> Updated plex user id to $SET_PLEX_UID"

    usermod -d $PLEX_CONFIG_DIR $PLEX_USER_NAME
    rm -rf $TEMP_HOME_DIR

  else
    echo "=> Requested user id ($SET_PLEX_UID) matches plex user id ($PLEX_USER_ID), nothing to do"
  fi
fi

echo "=> Plex group id: $PLEX_GROUP_ID"

# Same for group id
if [ ! -z "${SET_PLEX_GID}" ]; then
  if [ ! "$PLEX_GROUP_ID" -eq "${SET_PLEX_GID}" ]; then
    groupmod -o -g "${SET_PLEX_GID}" $PLEX_USER_NAME
    echo "=> Updated plex group id to $SET_PLEX_GID"
  else
    echo "=> Requested group id ($SET_PLEX_GID) matches plex group id ($PLEX_GROUP_ID), nothing to do"
  fi
fi

# Remove any previous pid file. Plex wont start if this file is left over from a previous run
rm -rf /config/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid

# Start plex!
echo '=> Starting plex... to load the UI go to: http://{ip address of Pi}:32400/web'
echo
su plex -s $PLEX_PATH/Plex\ Media\ Server
