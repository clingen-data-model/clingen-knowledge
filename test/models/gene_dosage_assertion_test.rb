require 'test_helper'

class GeneDosageAssertionTest < ActiveSupport::TestCase

  test "should get gene dosage list" do
    genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)").order('g.symbol').page(1).per(50)
    assert_not_empty genes.to_a
    gene = genes.first
    assert_not gene.blank?
    assert_not gene.label.blank?
    assert_not_empty gene.dosage_assertions
    assert_not gene.dosage_assertions.first.date.blank?
  end

  test "haplo_iris should return list of URIs" do
    assert_not_empty GeneDosageAssertion.haplo_iris
  end

  test "triplo_iris should return list of URIs" do
    assert_not_empty GeneDosageAssertion.triplo_iris
  end

end
