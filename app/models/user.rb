# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class User < ActiveRecord::Base
  devise :database_authenticatable

  attr_accessible :name, :email

  blogs

  validates :name, presence: true, allow_blank: false
  validates :email, presence: true, allow_blank: false, length: { minimum: 6 }, uniqueness: true
end
