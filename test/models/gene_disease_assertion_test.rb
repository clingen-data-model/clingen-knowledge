require 'test_helper'

class GeneDiseaseAssertionTest < ActiveSupport::TestCase

  test "should get assertions list" do
    # Index @assertions from controller file
    assertions = GeneDiseaseAssertion.query_as(:a)
                    .return("a {.date, .perm_id, .score_string,
                             genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}],
                             diseases: [(d:RDFClass)<-[:has_object]-(a) | d {.curie, .label}],
                             interpretation: [(i:Interpretation)<-[:has_predicate]-(a) | i {.label}]}")
                    .to_a
                    .map(&:a)
                    .sort_by { |r| r[:genes].first[:symbol] }
    assert_not_empty assertions
    assertion = assertions.first
    assert_not assertion.blank?
    assert_not assertion[:perm_id].blank?
    assert_not assertion[:date].blank?
    assert_not assertion[:genes].first[:hgnc_id].blank?
    assert_not assertion[:genes].first[:symbol].blank?
    assert_not assertion[:diseases].first[:curie].blank?
    assert_not assertion[:diseases].first[:label].blank?
    assert_not_empty assertion[:interpretation]
    assert_not assertion[:interpretation].first[:label].blank?
  end

  test "should have assertion score info in JSON" do
    assertion = GeneDiseaseAssertion.find_by(perm_id: "8249")
    assertionScoreJson = ActiveSupport::JSON.decode(assertion[:score_string])
    assert_not_empty assertionScoreJson
    assert_not assertionScoreJson['data']['Gene'].blank?
    assert_not assertionScoreJson['data']['Disease'].blank?
    assert_not assertionScoreJson['data']['Hgnc'].blank?
    assert_not assertionScoreJson['data']['OrphaNet'].blank?
    assert_not assertionScoreJson['data']['Omim'].blank?
    assert_not assertionScoreJson['data']['ModeOfInheritance'].blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithLOF","value").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithLOF","tally").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithLOF","pmid").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","VariantIsDeNovo","tally").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","VariantIsDeNovo","pmid").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithNon-LOF","value").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithNon-LOF","tally").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","ProbandWithNon-LOF","pmid").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","TwoNariantsInTransAndAtLeastOneIsLOFOrDeNovo","value").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","TwoNon-LOFVariantsInTrans","tally").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","VariantEvidence","AutosomalDominantDisease","TwoNon-LOFVariantsInTrans","pmid").blank?
    assert_not assertionScoreJson.dig('GeneticEvidence','CaseLevelData','VariantEvidence','AutosomalDominantDisease','TwoNon-LOFVariantsInTrans','value').blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","SegregationEvidence","EvidenceOfSegregationInOneOrMoreFamilies","value").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","SegregationEvidence","EvidenceOfSegregationInOneOrMoreFamilies","tally").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","CaseLevelData","SegregationEvidence","EvidenceOfSegregationInOneOrMoreFamilies","pmid").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","SingleVariantAnalysis","value").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","SingleVariantAnalysis","tally").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","SingleVariantAnalysis","pmid").blank?
    assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","AggregateVariantAnalysis","value").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","AggregateVariantAnalysis","tally").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","Case-ControlData","AggregateVariantAnalysis","pmid").blank?
    assert_not assertionScoreJson.dig("summary","GeneticEvidencePointsTotal").blank?
    # assert_not assertionScoreJson.dig("GeneticEvidence","TotalGeneticEvidencePoints","notes").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","Function","value").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","Function","tally").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","Function","pmid").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","FunctionalAlteration","value").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","FunctionalAlteration","tally").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","FunctionalAlteration","pmid").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","ModelsRescue","value").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","ModelsRescue","tally").blank?
    assert_not assertionScoreJson.dig("ExperimentalEvidence","ModelsRescue","pmid").blank?
    assert_not assertionScoreJson.dig("summary","ExperimentalEvidenceTotal").blank?
    # assert_not assertionScoreJson.dig("ExperimentalEvidence","TotalExperimentalEvidencePoints","notes").blank?
    assert_not assertionScoreJson.dig("summary","GeneticEvidencePointsTotal").blank?
    assert_not assertionScoreJson.dig("summary","ExperimentalEvidencePointsTotal").blank?
    assert_not assertionScoreJson.dig("summary","EvidencePointsTotal").blank?
    assert_not assertionScoreJson.dig("ReplicationOverTime","YesNo").blank?
    assert_not assertionScoreJson.dig("summary","CalculatedClassification").blank?
    # assert_not assertionScoreJson.dig("ValidContradictoryEvidence","YesNo").blank?
    # assert_not assertionScoreJson.dig("ValidContradictoryEvidence","pmid").blank?
    assert_not assertionScoreJson.dig("summary","CalculatedClassificationDate").blank?
    # assert_not assertionScoreJson.dig("CuratorModifyCalculation","YesNo").blank?
    assert_not assertionScoreJson.dig("summary","CuratorClassification").blank?
    assert_not assertionScoreJson.dig("summary","CuratorClassificationDate").blank?
    # assert_not assertionScoreJson.dig("summary","CuratorClassificationNotes").blank?
    assert_not assertionScoreJson.dig("summary","FinalClassification").blank?
    assert_not assertionScoreJson.dig("summary","FinalClassificationDate").blank?
    assert_not assertionScoreJson.dig("summary","FinalClassificationNotes").blank?
  end

end
