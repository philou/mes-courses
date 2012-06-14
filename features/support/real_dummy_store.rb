# -*- coding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require File.join(Rails.root, "remote_spec", "models", "real_dummy_store_generator")
require File.join(Rails.root, "remote_spec", "models", "real_dummy_store_items_api")

Before do
    RealDummyStore.wipe_out
end
