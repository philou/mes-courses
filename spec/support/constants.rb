# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::Stores::Carts

  # Testing constants added to the Api class
  class Api
    def self.valid_login
      "valid-login"
    end
    def self.valid_password
      "valid-password"
    end
    def self.invalid_login
      "in" + valid_login
    end
    def self.invalid_password
      "in" + valid_password
    end
  end
end
