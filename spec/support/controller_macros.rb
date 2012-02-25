# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

module ControllerMacros

  def ignore_user_authentication
    before :each do
      controller.stub(:authenticate_user!)
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(stub_model(User))
    end
  end

end

