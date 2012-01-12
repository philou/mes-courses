#!/bin/sh

echo "Pushing code to heroku" &&
git checkout cms_branch &&
git merge -s subtree master &&
git push cms cms_branch:master &&
echo "Looading snippets and layouts in heroku db" &&
heroku rake file_system:to_db:layouts_and_snippets --app mes-courses-cms &&
git checkout master &&

echo "Master pushed to CMS"

