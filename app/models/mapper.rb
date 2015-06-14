class Mapper < ActiveRecord::Base
  attr_accessible :keyword_id, :resource_id
  belongs_to :keyword
  belongs_to :resource
end
