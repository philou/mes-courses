# Copyright (C) 2011, 2012 by Philippe Bourgau

module AuthenticationControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def ignore_user_authentication
      before :each do
        controller.stub(:user_signed_in?).and_return(false)
      end
    end
  end

  def stub_signed_in_user(attributes = {})
    controller.stub(:authenticate_user!)
    controller.stub(:user_signed_in?).and_return(true)
    controller.stub(:current_user).and_return(stub_model(User, attributes))
  end

end

