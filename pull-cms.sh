#!/bin/sh

echo "Pulling live db to cms_branch" &&
git checkout cms_branch &&
heroku db:pull --confirm mes-courses-cms --app mes-courses-cms &&
rake file_system:to_files:layouts_and_snippets &&
git add . &&
git commit -m "Merge live cms db (Bloging)" &&
echo "Merging to master branch" &&
git checkout master &&
git merge -s subtree cms_branch &&
echo "Preparing dev env"
cd cms &&
heroku db:pull --confirm mes-courses-cms --app mes-courses-cms &&
rake file_system:to_db:layouts_and_snippets &&
cd .. &&
echo "Finished"
