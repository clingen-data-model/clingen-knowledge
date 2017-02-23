class HomeController < ApplicationController

  def index
    t = params[:term]
    @genes = Gene.all(:g)
               .where("g.symbol starts with {term}")
               .params(term: t)
               .limit(10)
    
    @conditions = Condition.all(:c)
                    .where("c.label starts with {term}")
                    .params(term: t)
                    .limit(10)

    respond_to do |format|
      format.html do
        redirect_to @genes.first if @genes.length == 1 && @conditions.length == 0
        redirect_to @conditions.first if @conditions.length == 1 && @genes.length == 0
      end
      format.json {render json: @results, root: false}
    end

  end

end


	
