# Copyright (C) 2011 by Philippe Bourgau

class DummyStoreItemsAPI

  def initialize(uri)
    @uri = uri
  end

  attr_reader :uri

  def attributes
    {}
  end
  def categories
    [DummyCategoryWalker.new]
  end
  def items
    []
  end
end

class DummyCategoryWalker
  def link_text
    "Produits laitiers"
  end
  def attributes
    {}
  end
  def categories
    [DummySubCategoryWalker.new]
  end
  def items
    []
  end
end

class DummySubCategoryWalker
  def link_text
    "Laits"
  end
  def attributes
    {}
  end
  def categories
    []
  end
  def items
    [DummyItemWalker.new]
  end
end

class DummyItemWalker
  def link_text
    "Lait entier"
  end
  def attributes
    {:name => "Lait enier", :summary => "Lait entier", :price => 0.67, :remote_id => 12345}
  end
  def categories
    []
  end
  def items
    []
  end
end

