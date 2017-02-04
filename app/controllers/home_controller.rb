class HomeController < ApplicationController

  def index
    if params[:q]
      @results = Entity.where(label: params[:q])
    else
      @gene = Gene.limit(10)
    end
    respond_to do |format|
      format.html
      format.json {render json: @results, root: false}
    end

  end

end


	