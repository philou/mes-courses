# Copyright (C) 2011 by Philippe Bourgau

# Testing constants added to the StoreCartAPI class
class StoreCartAPI
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
