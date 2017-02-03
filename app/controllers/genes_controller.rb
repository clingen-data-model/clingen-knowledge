class GenesController < ApplicationController
  layout 'application'

  def index
  end

  def show
    @gene = Gene.find_by(hgnc_id: params[:id])
    @diseases = @gene.assertions.diseases
    @actionability = @gene.actionability_scores
  end

end
