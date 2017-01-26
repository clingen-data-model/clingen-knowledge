class GenesController < ApplicationController

  def show
    @gene = Gene.find_by(hgnc_id: params[:id])
    @diseases = @gene.assertions.diseases
  end

end
