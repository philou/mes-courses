require 'spec_helper'

describe "/item_sub_type/index" do
  before(:each) do
    render 'item_sub_type/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/item_sub_type/index])
  end
end
