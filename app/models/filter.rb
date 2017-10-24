class Filter < ActiveRecord::Base
	has_many :myfilters
  has_many :users, :through => :myfilters
end
