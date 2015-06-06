class Mapper < ActiveRecord::Base
  attr_accessible :key_id, :resource_id
  belongs_to :key
  belongs_to :resource
end
