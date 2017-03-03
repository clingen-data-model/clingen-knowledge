class ExternalResourcesGenesController < ApplicationController
  include ActionView::Helpers::TextHelper

  # Be sure to add here anything needed for the gene_facts partial
  def index
    @gene = Gene.find_by(hgnc_id: params[:gene_id])
    @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.assertions.diseases.distinct
    @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
                .where("a:GeneDosageAssertion")
  end
  
end
