require 'test_helper'

class GeneTest < ActiveSupport::TestCase

  test "should get paginated list of conditions" do
    conditions = Condition.page(@page).per(20)
    assert conditions.length == 20
    assert_not conditions.first.label.blank?
    assert_not conditions.first.curie.blank?
  end

  test "should generate actionability summary for condition" do
    condition = Condition.find_by_term("Aneurysm-osteoarthritis syndrome")
    assert_not_empty condition
    # condition = Condition.find_by_term("thymic dysplasia")
    assert_not_empty condition.assertions

    assertions = [GeneDosageAssertion, GeneDiseaseAssertion, ActionabilityAssertion]
    all3 = condition.select do |cond|
      cond_assertions = cond.assertions.map { |v| v.class }
      incl = assertions.map { |assertion| cond_assertions.include?(assertion) }
      !incl.include?(false)
    end
    assert_not_empty all3
    all3 = all3.first

    assert_not all3.label.blank?
    assert_not all3.curie.blank?
    assert_not all3.synonym.blank?
    assert_not all3.last_curated.blank?
  end

  test "should get condition info for given curie" do
    condition = Condition.find_by(curie: "OMIM_613795")
    assert_not condition.blank?
    assert_not condition.curie.blank?
    assert_not condition.label.blank?

    genes = condition.assertions.genes.distinct
    assert_not_empty genes

    gene = genes.first
    assert_not gene.label.blank?

    validity = condition.assertions(:n).with_associations(:interpretation, :genes).where("n:GeneDiseaseAssertion")
    validity_detail = validity.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
    assert_not validity_detail[gene.uuid].blank?
    assert_not_empty validity_detail[gene.uuid].interpretation
    assert_not validity_detail[gene.uuid].date.blank?
    assert_not validity_detail[gene.uuid].perm_id.blank?

    dosage = condition.assertions(:a).with_associations(:interpretation, :genes).where("a:GeneDosageAssertion")
    dosage_detail = dosage.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
    assert_not dosage_detail[gene.uuid].blank?
    assert_not_empty dosage_detail[gene.uuid].interpretation
    assert_not dosage_detail[gene.uuid].interpretation.first.label.blank?
    assert_not dosage_detail[gene.uuid].mdy_date.blank?
    assert_not dosage_detail[gene.uuid].genes.first.symbol.blank?

    assertion = condition.actionability_scores.find { |a| a[:gene].include?(gene.uuid) }
    assert_not_empty assertion[:interventions]
    assert_not_empty assertion[:interventions].first[:scores]
    assert_not assertion[:interventions].first[:label].blank?
    assert_not assertion[:date].blank?
    assert_not assertion[:file].blank?
  end

end
