class Zone < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :region
  has_and_belongs_to_many :pois, class_name: 'POI'

  scope :with_expanded_bounding_box, lambda {
    query = <<-SQL.squish
      ST_Expand(
        bounding_box::geometry,
        (ST_XMax(bounding_box::geometry) - ST_XMin(bounding_box::geometry)) * 2,
        (ST_YMax(bounding_box::geometry) - ST_YMin(bounding_box::geometry)) * 2
      )::geography AS expanded_bounding_box
    SQL
    select('*').select(query)
  }
end
