require 'test_helper'

class GeneTest < ActiveSupport::TestCase

  test "should get gene dosage list" do
    genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)").order('g.symbol').page(1).per(50)
    assert_not_empty genes.to_a
    gene = genes.first
    assert_not gene.blank?
    assert_not gene.label.blank?
    assert_not_empty gene.dosage_assertions
    assert_not gene.dosage_assertions.first.date.blank?
  end

end
