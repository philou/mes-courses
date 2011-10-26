#!/bin/sh

echo "Pushing to main repository" &&
git push main master &&
echo &&

echo "Deploying to mes-courses-cart-tester" &&
git push cart-tester master &&
heroku rake db:migrate --app mes-courses-cart-tester &&
echo &&

echo "Deploying to mes-courses-integ" &&
git push integ master &&
heroku rake db:migrate --app mes-courses-integ &&
echo &&

echo "master branch pushed to main, integ and testers"
