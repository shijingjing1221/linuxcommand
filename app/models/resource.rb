class Resource < ActiveRecord::Base
    attr_accessible :name, :rtype, :note
    has_many :mappers


    def tags
        tags = ['RHEL7']
        for m in self.mappers do
            tags << m.keyword.name
            return tags
        end
    end

    def source
        return  {title:  "Linux command", link: "http://www.linuxcommand.cn?keyword="+self.mappers.first.keyword.name}
    end

    def get_defined_json
        self.to_json(
        {
            methods: [:tags,:source],
            only:[:id, :name, :rtype]
        })
    end
end
