
# A know dish
class Dish < ActiveRecord::Base
  has_and_belongs_to_many :items
end
