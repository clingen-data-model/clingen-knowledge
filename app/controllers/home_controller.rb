class HomeController < ApplicationController

  def index
    @term = params[:term]

    respond_to do |format|
      format.html do
        if @term
          @genes = Gene.find_by_term(@term).order(num_curations: :desc)
                     .limit(20)
          @conditions = Condition.find_by_term(@term).order(num_curations: :desc)
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
        redirect_to @genes.first if @genes && @genes.length == 1 && @conditions.length == 0
        redirect_to @conditions.first if @conditions && @conditions.length == 1 && @genes.length == 0
      end
      format.json do 
        # return formatted json for typeahead
        if @term
          search_term = @term.upcase
          @genes = Gene.all(:g).where("g.symbol starts with {term}")
                     .params(term: search_term).limit(10).to_a
          @conditions = Condition.all(:c).where("c.search_label contains {term}")
                          .params(term: search_term).limit(10).to_a
          @drugs = Drug.all(:d).where("d.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          terms = @genes + @conditions + @drugs
          @result = terms.map { |t| {label: "#{t.label} (#{t.curie.tr '_', ':'})", url: url_for(t)} }
          render json: @result
        end
      end
    end
  end
end


	
