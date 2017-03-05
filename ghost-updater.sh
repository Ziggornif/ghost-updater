#!/bin/bash
# Ghost updater v1
# @author : Matthieu Drouian <matthieudrouian@gmail.com> (https://github.com/Ziggornif) 
#
# Warning :
# -----------
# Change ghost dirs with your own values !
#

#Paths
NOW=$(date +'%s%N' | cut -b1-13)
NAME=ghost
GHOST_ROOT=/var/www/ghost
GHOST_WORK=/usr/ghost_work
GHOST_BACKUP=/usr/ghost_backup
GHOST_GROUP=ghost
GHOST_USER=ghost

#Stopping ghost service
service ghost stop

#Backup
cp -R $GHOST_ROOT $GHOST_BACKUP"/backup_"$NOW

#Download the latest ghost version and unzip it
cd $GHOST_WORK
curl -LOk https://ghost.org/zip/ghost-latest.zip
unzip ghost-latest.zip -d ghost-temp

#Delete old files
cd $GHOST_ROOT
rm -rf core index.js package.json npm-shrinkwrap.json

#Ghost core update
cp -R $GHOST_WORK/ghost-temp/core .
cp -R $GHOST_WORK/ghost-temp/index.js .
cp -R $GHOST_WORK/ghost-temp/package.json .
cp -R $GHOST_WORK/ghost-temp/npm-shrinkwrap.json .

#Fix permisions
chown -R ghost:ghost $GHOST_ROOT

#NPM update
rm -rf node_modules
npm cache clean
npm install --production

#Start ghost
service ghost start

#Cleaning
rm $GHOST_WORK/ghost-latest.zip
rm -rf $GHOST_WORK/ghost-temp

#Done !