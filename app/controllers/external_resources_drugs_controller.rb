class ExternalResourcesDrugsController < ApplicationController
  include ActionView::Helpers::TextHelper

  # Be sure to add here anything needed for the gene_facts partial
  def index
    expires_in 4.hours, public: true

    curie = params[:drug_id][6, 30]
    @drug = Drug.find_by(curie: curie)
    #@drug = Drug.find_by(curie: curie)
    @term_label = truncate(@drug.label, :length => 30, :omission => '...')
    @term_curie = truncate(@drug.curie)

    @pageTitle = @term_label


    ## Passes the term queries to analytics
    @analyticsDimension6  = @drug.label
    @analyticsDimension7  = "KB Drugs - External Resources"
    @analyticsDimension6  = @drug.label

  end
  
end
