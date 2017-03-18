class GeneDosageController < ApplicationController

  def index
    expires_in 4.hours, public: true

    page = params[:page] || 1
    # @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)

    #@genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)")
    #           .with_associations(:dosage_assertions).page(page).per(20)

    # @assertions = GeneDosageAssertion.all.limit(100).page(page).per(20)

    @genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)").order('g.symbol').page(page).per(50)
  
    @pageTitle = "Gene Dosage Curations"

    @analyticsDimension7  = "KB Gene Dosage - Index"
  end

end
