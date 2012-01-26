# Copyright (C) 2012 by Philippe Bourgau

class ChangeAdminEmail < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  GOOGLE_EMAIL = "philippe.bourgau@gmail.com"
  MES_COURSES_EMAIL = "philippe.bourgau@mes-courses.fr"

  def self.up
    update_email!(GOOGLE_EMAIL, MES_COURSES_EMAIL)
  end

  def self.down
    update_email!(MES_COURSES_EMAIL, GOOGLE_EMAIL)
  end

  private
  def self.update_email!(old_email, new_email)
    User.find_by_email!(old_email).update_attributes!(:email => new_email)
  end
end
