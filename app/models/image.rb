class Image < ApplicationRecord
  acts_as_taggable
  reverse_geocoded_by :latitude, :longitude
  validates :url, uniqueness: true, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
