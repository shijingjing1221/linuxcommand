class AdminController < ApplicationController
    def get_commands
        @resources = Resource.find_all_by_rtype(0);
        render '/admin/commands.erb', layout: false, content_type: 'application/text', filename: 'commands.json'
    end
end
