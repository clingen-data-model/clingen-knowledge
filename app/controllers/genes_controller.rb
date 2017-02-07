class GenesController < ApplicationController


  def index
  	@genes = Gene.limit(10)
  	# @genes = Gene.order(:name).page params[:page]
  	# @genes = Gene.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @gene = Gene.find_by(hgnc_id: params[:id])
    @diseases = @gene.assertions.diseases
    @actionability = @gene.actionability_scores
  end

end
