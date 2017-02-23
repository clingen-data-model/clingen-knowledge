class GenesController < ApplicationController
  include ActionView::Helpers::TextHelper


  def index
  	@genes = Gene.all.limit(11)
        if params[:curated]
          @genes = Gene.all(:g).where("(g)<-[:has_subject]-(:Assertion)").limit(20)
        end
  	# @genes = Gene.order(:name).page params[:page]
  	# @genes = Gene.paginate(:page => params[:page], :per_page => 30)

        respond_to do |format|
          format.json do 
            @genes = Gene.all(:g).where("g.symbol starts with {symbol}")
                       .params(symbol: params[:term]).limit(10)
            render json: @genes, root: false
          end
          format.html
        end
  end

  def show
    @gene = Gene.find_by(hgnc_id: params[:id])
    @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.assertions.diseases.distinct
    @actionability = @gene.actionability_scores
    @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
                .where("a:GeneDosageAssertion")
    @validity = @gene.assertions(:n).with_associations(:interpretation, :diseases)
                  .where("n:GeneDiseaseAssertion")
    @diseases_detail = @validity.reduce({}) do |h, i|
      h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
    end
  end

end
