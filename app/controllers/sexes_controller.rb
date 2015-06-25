class SexesController < ApplicationController

  def api_list
    @sexes = Sex.all
  end

end
