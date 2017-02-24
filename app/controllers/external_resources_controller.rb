class ExternalResourcesController < ApplicationController

  def index
  	@gene = Gene.find_by(hgnc_id: params[:gene_id])
  end
  
end
