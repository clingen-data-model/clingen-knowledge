class GenesController < ApplicationController


  def index
  	@genes = Gene.all.limit(11)
  	# @genes = Gene.order(:name).page params[:page]
  	# @genes = Gene.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @gene = Gene.find_by(hgnc_id: params[:id])
    @diseases = @gene.assertions.diseases
    @actionability = @gene.actionability_scores
    @validity = @gene.assertions(:n).with_associations(:interpretation, :diseases)
                  .where("n:GeneDiseaseAssertion")
    @diseases_detail = @validity.reduce({}) do |h, i|
      h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
    end
  end

end
