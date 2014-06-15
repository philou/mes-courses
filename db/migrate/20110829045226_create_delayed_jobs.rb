# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau
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


class CreateDelayedJobs < ActiveRecord::Migration
  def self.up
    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0      # jobs can jump to the front of
      table.integer  :attempts, :default => 0      # retries, but still fail eventually
      table.text     :handler                      # YAML object dump
      table.text     :last_error                   # last failure
      table.datetime :run_at                       # schedule for later
      table.datetime :locked_at                    # set when client working this job
      table.datetime :failed_at                    # set when all retries have failed
      table.text     :locked_by                    # who is working on this object
      table.timestamps
    end
  end
  def self.down
    drop_table :delayed_jobs
  end
end
