class ApiController < ActionController::Base
  protect_from_forgery

  def get_keywords
    @keywords = Keyword.all;
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
end