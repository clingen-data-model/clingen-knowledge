class DrugsController < ApplicationController
	

  # def show
  #   @gene = Gene.find_by(hgnc_id: params[:id])
  #   @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
  #   @term_id = truncate(@gene.hgnc_id)
  #   @diseases = @gene.assertions.diseases.distinct
  #   @actionability = @gene.actionability_scores
  #   if @actionability.length > 0
  #     @actionability_diseases = @actionability.map {|a| a[:disease]}.flatten
  #   end
  #   @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
  #               .where("a:GeneDosageAssertion")
  #   @validity = @gene.assertions(:n).with_associations(:interpretation, :diseases)
  #                 .where("n:GeneDiseaseAssertion")
  #   @diseases_detail = @validity.reduce({}) do |h, i|
  #     h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
  #   end
  #   @dosage_detail = @dosage.reduce({}) do |h, i|
  #     h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
  #   end
  # end

  def show
    @drug = Drug.find_by(uuid: params[:id])
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
