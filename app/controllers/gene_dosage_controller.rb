class GeneDosageController < ApplicationController

  def index
    @genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)")
               .with_associations(:dosage_assertions).limit(100)
    @assertions = GeneDosageAssertion.all.limit(100)
  end

end
