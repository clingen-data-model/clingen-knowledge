class ExternalResourcesConditionsController < ApplicationController
  include ActionView::Helpers::TextHelper

  # Be sure to add here anything needed for the gene_facts partial
  def index
    @condition = Condition.find_by(curie: params[:condition_id])
    @term_label = truncate(@condition.label, :length => 50, :omission => '...')
    @term_id = @condition.curie
    #@term_curie = @condition.curie.gsub! '_', ':'
    @term_curie = @condition.curie

    @genes = @condition.assertions.genes.distinct
    @actionability  = @condition.actionability_scores
    @validity = @condition.assertions(:n).with_associations(:interpretation, :genes)
                  .where("n:GeneDiseaseAssertion")
    @validity_detail = @validity.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
  end
end
