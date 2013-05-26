# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Stores
    module Carts

      # Testing constants added to the Api class
      module TestingCredentials
        def valid_login
          "valid-login"
        end
        def valid_password
          "valid-password"
        end
        def invalid_login
          "in" + valid_login
        end
        def invalid_password
          "in" + valid_password
        end
      end

      Api.send(:extend, TestingCredentials)

    end
  end
end
