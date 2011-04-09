#!/bin/sh

git checkout cms_branch &&
git merge -s subtree cms_branch &&
RAILS_ENV=production rake fs:to_db &&
git commit -m "Push local changes to cms db (Bloging)" &&
git push cms cms_branch:master &&
RAILS_ENV=production heroku db:push --app mes-courses-cms &&
git checkout master &&

echo "Master pushed to cms"