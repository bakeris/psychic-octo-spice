class CivilitiesController < ApplicationController

  def api_list
    @civilities = Civility.all
  end

end
