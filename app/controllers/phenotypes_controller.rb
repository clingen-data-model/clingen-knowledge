class PhenotypesController < ApplicationController
  def index
    if params[:term]
      @phenotypes = Phenotype.all(:p).where("p.label contains {term}").params(term: params[:term]).limit(10)
    else
      @phenotypes = Phenotype.all.limit(10)
    end
    respond_to do |format|
      format.html
      format.json do
        result = {options: @phenotypes.map { |p| {value: p.iri, label: p.label} }}
        render json: result
      end
    end
  end
end
