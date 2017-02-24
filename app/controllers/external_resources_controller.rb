class ExternalResourcesController < ApplicationController
  include ActionView::Helpers::TextHelper

<<<<<<< HEAD
  # Be sure to add here anything needed for the gene_facts partial
=======

>>>>>>> 98496623289c5f1b067d73228ecea83a08e9454f
  def index
    @gene = Gene.find_by(hgnc_id: params[:gene_id])
    @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.assertions.diseases.distinct
    @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
                .where("a:GeneDosageAssertion")
  end
  
end
