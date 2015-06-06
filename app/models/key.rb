class Key < ActiveRecord::Base
  attr_accessible :name
  has_many :mappers
  def get_resource_ids
    rids = []
    for m in self.mappers do
        rids << m.resource_id
      end

      return rids
    end

    def commands
      @resource_ids = get_resource_ids()
      return Resource.find(:all, :conditions=>{:rtype=>0, :id=>@resource_ids})
    end

    def files
      @resource_ids = get_resource_ids()
      return Resource.find(:all, :conditions=>{:rtype=>1, :id=>@resource_ids})
    end
  end
