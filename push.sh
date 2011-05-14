#!/bin/sh

git push origin master &&

git push dev master &&
heroku rake db:migrate --app mes-courses-dev &&

git push watchdog master &&
heroku rake db:migrate --app mes-courses-watchdog &&

echo "master branch pushed to origin, dev, and watchdog"
