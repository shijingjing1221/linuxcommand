class CreateKeywordBashconditionandstructures < ActiveRecord::Migration
  def up
    keywords = ["Shell Scripts with Conditionals and Control Structures"]
    resource_type_command = 0
    resource_type_file = 1
    command_names = ['for ARG in "$@"; do echo $ARG done',
                     'echo "There are $# arguments."',
                     './showargs 1 2 3',
                     "echo $?",
                     'grep localhost /etc/hosts',
                     '[ 1 -eq 1 ]; echo $?',
                     '[ abc == abc ]; echo $?',
                     'STRING=''; [ -z "$STRING" ]; echo $?',
                     "STRING='abc'; [ -n \"$STRING\" ]; echo $?",
                     'if [ "$VHOSTNAME" = '' ] || [ "$TIER" = '' ]; then'
                     ]
    file_names = [""]

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
