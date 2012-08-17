#!/bin/usr/env ruby

require_relative '../deployment'
include MesCourses::Deployment

with_repo_argument("raw_deploy", "Immediately deploys master branch to the specified remote heroku repo, without any confirmation !") do |repo|
  end_deploy(repo)
end
