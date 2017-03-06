class GeneDosageController < ApplicationController

  def index
    page = params[:page] || 1
    @genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)")
               .with_associations(:dosage_assertions).page(page).per(20)
    # @assertions = GeneDosageAssertion.all.limit(100).page(page).per(20)
  end

end
