require 'test_helper'

class GeneTest < ActiveSupport::TestCase

  test "should find by term" do
    genes = Gene.find_by_term("SMAD3")
    assert_not_empty genes
  end

  test "should generate complete list for curation summary page" do 
    summary = Gene.genes_summary
    assert_not_empty summary
    smad3 = summary.select { |i| i[:hgnc_id] == "HGNC:6769" }.first
    assert_not_empty smad3
    assert_not_empty smad3[:validity]
    assert_not_empty smad3[:dosage]
    assert_not_empty smad3[:actionability]
  end

  test "should generate actionability summary for gene" do
    summary = Gene.find_by(hgnc_id: "HGNC:6769").actionability_scores
    assert_not_empty summary
    sample = summary.first
    assert_not_empty sample[:interventions].first[:scores]
    assert_not_empty sample[:disease]
    assert_not_empty sample[:file]
    assert_not_empty sample[:date]
  end

end
