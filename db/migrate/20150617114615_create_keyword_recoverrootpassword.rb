class CreateKeywordRecoverrootpassword < ActiveRecord::Migration
  def up
    keywords = ["Recovering the root password"]
    resource_type_command = 0
    resource_type_file = 1
    command_names = ["linux 16...rd.break console=tty0;ctrl+x",
                     "mount -oremount,rw /sysroot",
                     "chroot /sysroot",
                     "passwd root",
                     "touch /.autorelabel",
                     "exit;exit;"
                     ]
    file_names = ["/etc/shadow/*"]

    keywordModels = []
    resourceModels = []
    keywords.each do |keywordString|
      keywordModel = Keyword.create(name: keywordString);
      keywordModels.push(keywordModel)
    end
    command_names.each do |command_name|
      resource = Resource.create(rtype: resource_type_command, name: command_name)
      resourceModels.push(resource)
    end

    file_names.each do |file_name|
      resource = Resource.create(rtype: resource_type_file, name: file_name)
      resourceModels.push(resource)
    end

    keywordModels.each do |keywordModel|
      resourceModels.each do |resourceModel|
        Mapper.create(keyword_id: keywordModel.id, resource_id: resourceModel.id)
      end
    end
  end

  def down
  end
end
