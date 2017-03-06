class DrugsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def show
    @drug = Drug.find_by(curie: params[:id])
    @term_label = truncate(@drug.label, :length => 20, :omission => '...')
    @term_id = truncate(@drug.curie)
    @term_curie = truncate(@drug.curie)
  end

  def index
    @page = params[:page] || 1
    if params[:term]
      @drugs = Drug.find_by_term(params[:term]).page(@page).per(20)
    else
      @drugs = Drug.page(@page).per(20)
    end
  end

end
