# Copyright (C) 2013 by Philippe Bourgau

require 'guard/jasmine/task'

Guard::JasmineTask.new do |task|
  task.options = '--server=jasmine_gem --server-timeout=60'
end
