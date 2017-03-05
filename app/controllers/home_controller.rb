class HomeController < ApplicationController

  def index
    @term = params[:term]

    if @term
      @genes = Gene.find_by_term(@term)
                 .limit(20)

      @conditions = Condition.find_by_term(@term)
                      .limit(20)

      @drugs = Drug.find_by_term(@term)
                 .limit(20)

      if @genes.size > 0
        @active_class = :genes
      elsif @conditions.size > 0
        @active_class = :conditions
      elsif @drugs.size > 0
        @active_class = :drugs
      else
        @active_class = :none
      end
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


	
