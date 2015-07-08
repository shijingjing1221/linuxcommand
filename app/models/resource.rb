class Resource < ActiveRecord::Base
  attr_accessible :name, :rtype, :note
  has_many :mappers
end
