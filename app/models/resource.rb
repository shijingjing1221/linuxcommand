class Resource < ActiveRecord::Base
  attr_accessible :name, :rtype
  has_many :mappers
end
