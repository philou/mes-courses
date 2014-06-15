# Copyright (C) 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.



#!/bin/usr/env ruby

require_relative '../deployment'
include MesCourses::Deployment

with_trace_argument "INTERNAL USE : Deploys master branch to the specified remote heroku repo", (proc do
  opt :repo, "name of the remote git repo, the corresponding app should be named mes-courses-<repo> by convention", required: true, type: :string
  opt :refresh_db, "refresh the database from #{BETA} before deploying"
end) do |options|
  refresh_db(options[:repo]) if options[:refresh_db]
  deploy(options[:repo])
end
