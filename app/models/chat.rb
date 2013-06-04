class Chat < ActiveRecord::Base
	belongs_to :room
	belongs_to :user

	def size
		100
	end
end
