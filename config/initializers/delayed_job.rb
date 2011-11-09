# Copyright (C) 2011 by Philippe Bourgau

# needed with delayed_job <= 2.0.6
Delayed::Worker.backend = :active_record
