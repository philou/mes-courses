# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

# custom matchers
require_relative '../../spec/support/constants'
require_relative '../../spec/support/mostly_matcher'
require_relative '../../spec/support/all_do_matcher'
require_relative '../../spec/support/have_non_nil_matcher'
require_relative '../../spec/support/have_place_matcher'
require_relative '../../spec/support/highlight_place_matcher'
require_relative '../../spec/support/have_body_id_matcher'
require_relative '../../spec/support/contain_a_matcher'
require_relative '../../spec/support/page_part'
require_relative '../../spec/support/knows_page_parts'

World(KnowsPageParts)