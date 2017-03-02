class DrugsController < ApplicationController
	
  def show
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
