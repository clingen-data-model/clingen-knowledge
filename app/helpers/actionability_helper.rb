module ActionabilityHelper

  def category_score(category, a)
    return "" unless a
    matches = ActionabilityAssertion.act_scores[category].keys
    result = a.find { |i| i && matches.include?(i[:iri]) }
    result ? result[:label] : ""
  end

  # Sort alphabetically by first gene symbol. If more than one gene per assertion, sort the gene array for that assertion first.
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

end
