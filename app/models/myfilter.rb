class Myfilter < ActiveRecord::Base
	belongs_to :user
	belongs_to :filter
end
