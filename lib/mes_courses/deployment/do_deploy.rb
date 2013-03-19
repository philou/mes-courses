#!/bin/usr/env ruby

require_relative '../deployment'
include MesCourses::Deployment

with_trace_argument "INTERNAL USE : Deploys master branch to the specified remote heroku repo", (proc do
  opt :repo, "name of the remote git repo, the corresponding app should be named mes-courses-<repo> by convention", required: true, type: :string
end) do |options|
  deploy(options[:repo])
end
