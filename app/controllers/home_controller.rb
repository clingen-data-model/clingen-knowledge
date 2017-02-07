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
      format.html
      format.json {render json: @results, root: false}
    end

  end

end


	
