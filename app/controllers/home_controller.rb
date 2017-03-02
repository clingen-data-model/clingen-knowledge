class HomeController < ApplicationController

  def index
    t = params[:term]

    if t
      @genes = Gene.find_by_term(t)
                 .limit(20)

      @conditions = Condition.find_by_term(t)
                      .limit(20)

      @drugs = Drug.find_by_term(t)
                 .limit(20)
    end


    respond_to do |format|
      format.html do
        redirect_to @genes.first if @genes && @genes.length == 1 && @conditions.length == 0
        redirect_to @conditions.first if @conditions && @conditions.length == 1 && @genes.length == 0
      end
      format.json {render json: @results, root: false}
    end

  end

end


	
