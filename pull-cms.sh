#!/bin/sh

git checkout cms_branch &&
RAILS_ENV=production heroku db:pull --app mes-courses-cms &&
RAILS_ENV=production rake db:to_fs &&
git add . &&
git commit -m "Merge live cms db (Bloging)" &&
git checkout master &&
git merge -s subtree cms_branch &&

echo "CMS pulled to master"
