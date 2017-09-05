require 'test_helper'

#### SAME CODE AS IN THE actionability_helper.rb FILE ####
#### NEED TO UPDATE THIS CODE WHEN IT IS UPDATED IN THE ABOVE FILE ####
# Sort alphabetically by first gene symbol. If more than one gene per assertion, sort the gene array for that assertion first.
# NOTE: modifies the original object slightly
def sort_by_first_gene_symbol(data)
  (0...data.length).each do |i|
    if data[i][:genes].length > 1
      data[i][:genes] = data[i][:genes].sort_by { |h| h[:symbol] }
    end
  end
  data.sort_by { |r| r[:genes].first[:symbol] }
end

# return structure to power index page
def index_list(page = 1, limit = 20)
  assertions = ActionabilityAssertion.query_as(:a)
                 .return("a {.file, .date, genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}],
                conditions: [(c:Condition)<-[:has_object]-(a) | c {.label, .curie}],
                interventions: [(a)<-[:was_generated_by]-(i:ActionabilityInterventionAssertion) | i {
                label: head([(i)-[:has_object]->(int:Intervention) | int.label]),
                scores: [(i)<-[:was_generated_by]-(s:ActionabilityScore) |
                        head([(s)-[:has_predicate]->(p:Interpretation) | p {.iri, .label}])]}]}")
                 .to_a.map(&:a)

  sort_by_first_gene_symbol(assertions)
end
########################################################################

class GeneTest < ActiveSupport::TestCase

  test "should get assertions list" do
    assertions = index_list(1)
    assert_not_empty assertions
    assertion = assertions.first
    assert_not assertion.blank?
    assert_not_empty assertion[:genes]
    assert_not assertion[:genes].first[:symbol].blank?
    assert_not assertion[:genes].first[:hgnc_id].blank?
    assert_not_empty assertion[:conditions]
    assert_not assertion[:conditions].first[:label].blank?
    assert_not assertion[:conditions].first[:curie].blank?
    assert_not_empty assertion[:interventions]
    assert_not assertion[:interventions].first[:label].blank?
    assert_not assertion[:interventions].first[:scores].blank?
    assert_not assertion[:file].blank?
    assert_not assertion[:date].blank?
  end

end
