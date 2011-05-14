#!/bin/sh

echo "Pushing to main repository" &&
git push origin master &&
echo &&

echo "Deploying to mes-courses-dev" &&
git push dev master &&
heroku rake db:migrate --app mes-courses-dev &&
echo &&

echo "Deploying to mes-courses-watchdog" &&
git push watchdog master &&
heroku rake db:migrate --app mes-courses-watchdog &&
echo &&

echo "master branch pushed to origin, dev, and watchdog"
