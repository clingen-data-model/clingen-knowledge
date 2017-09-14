require 'test_helper'

class DrugTest < ActiveSupport::TestCase

  test "should return list of drugs" do
    drugs = Drug.page(1).per(20)
    assert_not_empty drugs.to_a
    assert drugs.length == 20, "20 drugs should be returned"
    assert_not drugs.first.label.blank?
    assert_not drugs.first.curie.blank?
  end

  test "should return drug info" do
    drug = Drug.find_by(curie: "379327")
    assert_not drug.blank?
    assert_not drug.label.blank?
    assert_not drug.curie.blank?

    drug = Drug.find_by_term("Lactate / Urea Topical Cream")
    assert_not_empty drug
    assert_not drug.first.label.blank?
    assert_not drug.first.curie.blank?
  end

end
