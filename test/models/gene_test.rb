require 'test_helper'

class GeneTest < ActiveSupport::TestCase

  test "should find by term" do
    genes = Gene.find_by_term("SMAD3")
    assert_not_empty genes
    gene = genes.first
    assert_not gene[:symbol].blank?
    assert_not gene[:hgnc_id].blank?
    assert_not gene[:name].blank?
    assert_not gene[:last_curated].blank?
    assert_not gene[:location].blank?

    dosage_assertions = gene.dosage_assertions
    assert_not_empty dosage_assertions
    assert_not_empty dosage_assertions.first.interpretation
    assert_not dosage_assertions.first.interpretation.first.label.blank?

    disease_assertions = gene.assertions.diseases.distinct
    assert_not_empty disease_assertions
    assert_not disease_assertions.first.iri.blank?
    assert_not disease_assertions.first.label.blank?
    assert_not disease_assertions.first.curie.blank?

    validity = gene.assertions(:n).with_associations(:interpretation, :diseases).where("n:GeneDiseaseAssertion")
    diseases_detail = validity.reduce({}) do |h, i|
      h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
    end
    assert_not_empty diseases_detail[gene.assertions.diseases.distinct.first.iri].interpretation
    assert_not diseases_detail[gene.assertions.diseases.distinct.first.iri].interpretation.first.label.blank?
    assert_not diseases_detail[gene.assertions.diseases.distinct.first.iri].date.blank?
    assert_not diseases_detail[gene.assertions.diseases.distinct.first.iri].perm_id.blank?
  end

  test "should generate complete list for curation summary page" do
    summary = Gene.genes_summary
    assert_not_empty summary
    smad3 = summary.select { |i| i[:hgnc_id] == "HGNC:6769" && i[:validity] != [] && i[:dosage] != []}.first
    assert_not_empty smad3
    assert_not_empty smad3[:validity]
    assert_not_empty smad3[:dosage]
    assert_not smad3[:dosage].first[:iri].blank?
    assert_not smad3[:dosage].first[:short_label].blank?
    assert_not_empty smad3[:actionability]
  end

  test "should generate actionability summary for gene" do
    summary = Gene.find_by(hgnc_id: "HGNC:6769").actionability_scores
    assert_not_empty summary

    sample = summary.first
    assert_not_empty sample[:interventions].first[:scores]
    assert_not_empty sample[:disease]
    assert_not sample[:interventions].first[:label].blank?
    assert_not sample[:file].blank?
    assert_not sample[:date].blank?

    scores = ActionabilityScore.labels_to_h(sample[:interventions].first[:scores])
    assert_not scores[:severity].blank?
    assert_not scores[:likelihood].blank?
    assert_not scores[:efficacy].blank?
    assert_not scores[:safety].blank?
  end

end
