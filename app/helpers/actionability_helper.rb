module ActionabilityHelper

  def category_score(category, a)
    return "" unless a
    matches = ActionabilityAssertion.act_scores[category].keys
    result = a.find { |i| i && matches.include?(i[:iri]) }
    result ? result[:label] : ""
  end

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
  # TODO change title to label
  # return structure to power index page
  def index_list(page = 1, limit = 20)
    assertions = ActionabilityAssertion.query_as(:a)
                   .return("a {.report, .file, .date, genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}],
                  conditions: [(c:DiseaseConcept)-[:has_object|:equivalentTo*1..2]-(a) | c {.label, .curie}],
                  outcomes: [(a)<-[:has_subject]-(o:ActionabilityOutcomeAssertion) |
                             o {.label, scores: [(o)<-[:has_subject]-(:ActionabilityScore)-[:has_predicate]->(so:Interpretation) | so {.label}],
 interventions:                                [(o)<-[:has_subject]-(i:ActionabilityInterventionAssertion) | i {.label, scores:
                                [(i)<-[:has_subject]-(:ActionabilityScore)-[:has_predicate]->(si:Interpretation) | si {.label}]}]}]}")
                   .to_a.map(&:a)

    sort_by_first_gene_symbol(assertions)
  end

end
