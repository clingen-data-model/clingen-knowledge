class ExternalResourcesGenesController < ApplicationController
  include ActionView::Helpers::TextHelper

  # Be sure to add here anything needed for the gene_facts partial
  def index
    expires_in 1.minute, public: true

    @gene = Gene.find_by(hgnc_id: params[:gene_id])
    @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.assertions.diseases.distinct
    @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
                .where("a:GeneDosageAssertion")

    @pageTitle = @term_label


    @analyticsDimension7  = "KB Genes - External Resources"
    if @genes || @actionability || @validity 
      @analyticsDimension1  = @gene.symbol
    else
      @analyticsDimension3  = @gene.symbol
    end
  end
  
end
