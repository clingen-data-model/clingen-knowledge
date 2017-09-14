class Condition < RDFClass

  property :search_label
  property :num_curations

  has_many :in, :assertions, type: :has_object, model_class: :Assertion

  def self.find_by_term(t)
    split_term = t.split(' ')
    Condition.all(:c)
      .where("all(t in {terms} where c.label =~ ('(?i).*' + t + '.*'))")
      .params(terms: split_term)
  end

  def to_param
    curie
  end

  def actionability_scores
    assertions.query_as(:a)
      .where("(a:ActionabilityAssertion)")
      .return(" a {.uuid, .date, .file,
	gene: [(a)-[:has_subject]->(g:Gene) | g.uuid],
    interventions: [(a)                             <-[:was_generated_by]-(a2:ActionabilityInterventionAssertion)-[:has_object]->(i:Intervention) | a2 {label: i.label,
    scores: [(a2)<-[:was_generated_by]-(a3:ActionabilityScore) |
            	a3 {score: [(a3)-[:has_predicate]->(s) | s.iri ],
                	strength: [(a3)-[:has_evidence_strength]->(s) | s.iri] } ]      }]}")
      .to_a.map(&:a)
  end

end
