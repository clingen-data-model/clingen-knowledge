class HomeController < ApplicationController

  def index
    @results = Entity.where(label: params[:term]) if params[:term]
    respond_to do |format|
      format.html
      format.json { render json: @results}
    end
  end

end
