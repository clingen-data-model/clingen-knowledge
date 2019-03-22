class HomeController < ApplicationController
  def index
    @term         = params[:term]
    @termGene     = params[:termGene]
    @termDisease  = params[:termDisease]
    expires_in 10.minutes, public: true

    if !@term
      @term = params[:'mainSearchCriteria.v.dn']
    end

    if !@termGene
      @termGene = params[:'mainSearchCriteria.v.dn']
    end

    ## Passes the term queries to analytics
    @analyticsDimension5  = @term
    @analyticsDimension7  = "KB Home - Index"

    respond_to do |format|


      format.html do

      redirect_back fallback_location: "https://clingen2019v2.creationproject.net/curation-activities/"

        if @term
          @genesFound = Gene.find_by_term(@term).order(num_curations: :desc)
          @genes = @genesFound.limit(20)
          @conditionsFound = Condition.find_by_term(@term).order(num_curations: :desc)
          @conditions = @conditionsFound.limit(20)
          @drugsFound = Drug.find_by_term(@term)
          @drugs = @drugsFound.limit(20)

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
          @genes = Gene.all(:g).where("g.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          @conditions = Condition.all(:c).where("c.search_label contains {term}")
                          .params(term: search_term).limit(10).to_a
          @drugs = Drug.all(:d).where("d.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          terms = @genes + @conditions + @drugs
          @result = terms.map { |t| {label: "#{t.label} (#{t.curie.tr '_', ':'})", url: url_for(t)} }
          render json: @result
        end
        if @termGene
          search_term = @termGene.upcase
          @genes = Gene.all(:g).where("g.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          terms = @genes 
          @result = terms.map { |t| {label: "#{t.label} (#{t.curie.tr '_', ':'})", url: url_for(t)} }
          render json: @result
        end
        if @termDisease
          search_term = @termDisease.upcase
          @conditions = Condition.all(:c).where("c.search_label contains {term}")
                          .params(term: search_term).limit(10).to_a
          terms = @conditions 
          @result = terms.map { |t| {label: "#{t.label} (#{t.curie.tr '_', ':'})", url: url_for(t)} }
          render json: @result
        end
        if @termOrig
          search_term = @term.upcase
          @genes = Gene.all(:g).where("g.search_label contains {term}")
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


	
