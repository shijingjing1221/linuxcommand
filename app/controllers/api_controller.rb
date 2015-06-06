class ApiController < ActionController::Base
  protect_from_forgery

  def get_keys
    @keys = Key.all;
    if params[:name_only] == 'true'
      render :json => @keys.as_json(only:[:id, :name])
    else
      render :json => @keys.as_json()
    end
  end

  def get_key
    @keys = Key.find(params[:id].to_i)
    render :json => @keys.as_json(
      {
        methods: [:commands,:files],
        only:[:id, :name]
    })
  end
end
