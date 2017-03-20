class DrugsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def show
    expires_in 1.minute, public: true

    curie = params[:id][6, 30]
    @drug = Drug.find_by(curie: curie)
    # @term_label = truncate(@drug.label, :length => 20, :omission => '...')
    # @term_id = truncate(@drug.curie)
    # @term_curie = truncate(@drug.curie)
    
    #  Nothing curated so send them right to external resources.
    redirect_to drug_external_resources_drugs_path(@drug)

  end

  def index
    expires_in 1.minute, public: true

    @page = params[:page] || 1
    if params[:term]
      @drugs = Drug.find_by_term(params[:term]).page(@page).per(20)
    else
      @drugs = Drug.page(@page).per(20)
    end


    @pageTitle = "Drugs"


    @analyticsDimension7  = "KB Drugs - Index"
  end

end
