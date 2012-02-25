# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

# Url visited during an import
class VisitedUrl < ActiveRecord::Base

  validates_presence_of :url
  validates_uniqueness_of :url

end
