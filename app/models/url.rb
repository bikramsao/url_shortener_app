class Url < ActiveRecord::Base
	validates :original_url, presence: true, uniqueness: { 
    message: "already has been used" }
end
