class ExternalResourcesDrugsController < ApplicationController
  include ActionView::Helpers::TextHelper

  # Be sure to add here anything needed for the gene_facts partial
  def index
    @drug = Drug.find_by(curie: params[:drug_id])
    @term_label = truncate(@drug.label, :length => 30, :omission => '...')
  end
  
end
