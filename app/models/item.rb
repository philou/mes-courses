
# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
end
