# Copyright (C) 2013 by Philippe Bourgau

require 'guard/jasmine/task'

Guard::JasmineTask.new do |task|
  task.options = '--server-timeout=90'
end
