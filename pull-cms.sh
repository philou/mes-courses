#!/bin/sh

echo "Pulling live db to cms_branch" &&
git checkout cms_branch &&
RAILS_ENV=production heroku db:pull --app mes-courses-cms &&
RAILS_ENV=production rake db:to_fs &&
git add . &&
git commit -m "Merge live cms db (Bloging)" &&
echo "Merging to master branch" &&
git checkout master &&
git merge -s subtree cms_branch &&
echo "Preparing dev env"
cd cms &&
cp db/production.cms.sqlite3.db db/development.cms.sqlite3.db &&
rake fs:to_db &&
cd .. &&
echo "Finished"

