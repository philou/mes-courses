# Copyright (C) 2010 by Philippe Bourgau

desc "Checks all specs and scenarios"
task :behaviours => [:spec, :cucumber, :environment] do
end
