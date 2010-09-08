require 'spec_helper'

describe ItemTypeController do

  #Delete these examples and add some real ones
  it "should use ItemTypeController" do
    controller.should be_an_instance_of(ItemTypeController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
