class Image < ActiveRecord::Base
	belongs_to :user
	mount_uploader :url, UrlUploader # Tells rails to use this uploader for this model.
  	validates :name, presence: true # Make sure the owner's name is present.
	attr_accessor :istrash
	attr_accessor :ownerId
	attr_accessor :user_id
	# attr_accessor :id
end
