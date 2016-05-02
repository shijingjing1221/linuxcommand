class ApiController < ActionController::Base
  protect_from_forgery

  def get_keywords
    @keywords = Keyword.order(:name);
    if params[:name_only] == 'true'
      render :json => @keywords.as_json(only:[:id, :name])
    else
      render :json => @keywords.as_json()
    end
  end

  def get_keyword
    @keywords = Keyword.find(params[:id].to_i)
    render :json => @keywords.as_json(
      {
        methods: [:commands,:files],
        only:[:id, :name]
    })
  end

  def create_keyword
    keyword = Keyword.create(:name => params[:name].to_s)
    render :json => keyword.as_json(
      {
        methods: [:commands,:files],
        only:[:id, :name]
    })
  end

  def create_resource
    kId = params[:id].to_i
    rtypeRaw = params[:resourceType].to_s
    rname = params[:name].to_s
    note = params[:note].to_s
    rtype = 0
    if rname != nil && rname != ''
      if rtypeRaw == "command"
        rtype =0
      else
        rtype =1
      end
      newResource = Resource.create(:rtype => rtype, :name => rname, :note => note)
      Mapper.create(:keyword_id => kId, :resource_id => newResource.id)
    end
    keyword = Keyword.find(params[:id].to_i)
    render :json => keyword.as_json(
      {
        methods: [:commands,:files],
        only:[:id, :name]
    })
  end

  def update_resource
    rId = params[:resourceId].to_i
    rname = params[:name].to_s
    note = params[:note].to_s
    rtype = 0
    if rname != nil && rname != ''
      resource = Resource.find_by_id(rId)
      resource.note = note
      resource.name = rname
      resource.save
    end
    render :json => resource.as_json()
  end
end
