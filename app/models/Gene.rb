class Gene
  include Neo4j::ActiveNode
  
  property :hgnc_id
  property :symbol
  property :name
  property :location
  property :last_curated
  property :num_curations

  has_many :in, :assertions, model_class: :Assertion, type: :has_subject
  has_many :in, :dosage_assertions, model_class: :GeneDosageAssertion, type: :has_subject

  def to_param
    hgnc_id
  end

  def label
    symbol
  end

  def curie
    hgnc_id
  end

  def self.find_by_term(t)
    Gene.all(:g)
      .where("g.search_label contains {term}")
      .params(term: t)
  end

  # Grand query to construct summary page
  def self.genes_summary
    Gene.query_as(:g)
      .where("(g)<-[:has_subject]-(:Assertion)")
      .return("g {.symbol, .hgnc_id,
          actionability: [(g)<-[:has_subject]-(a:ActionabilityAssertion) | a.uuid],
          validity: [(g)<-[:has_subject]-(a:GeneDiseaseAssertion)-[:has_predicate]->(i:Interpretation) | i.label],
          dosage: [(g)<-[:has_subject]-(a:GeneDosageAssertion)-[:has_predicate]->(i:Interpretation) | i {.iri, .short_label}]}").to_a.map(&:g)
  end

  # Grand query matching all actionability scores (given a gene)
  # Restricting returns in this query to actionability, but 
  # is feasible to do more

  # retrieve actionability scores for a given curation
  def actionability_scores
    assertions.query_as(:a)
      .where("(a:ActionabilityAssertion)")
      .return(" a {.uuid, .date, .file, 
	disease: [(a)-[:has_object]->(d:RDFClass) | d.iri],
    interventions: [(a)                             <-[:was_generated_by]-(a2:ActionabilityInterventionAssertion)-[:has_object]->(i:Intervention) | a2 {label: i.label,
    scores: [(a2)<-[:was_generated_by]-(a3:ActionabilityScore) |
            	a3 {score: [(a3)-[:has_predicate]->(s) | s.iri ],
                	strength: [(a3)-[:has_evidence_strength]->(s) | s.iri] } ]      }]}")
      .to_a.map(&:a)
  end


  def actionability_for_disease(disease)
    assertions.query_as(:a)
      .where('(a)-[:has_predicate]->(:Class {iri: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000082"})').where("(a)-[:has_object]->(:Class {iri: '#{disease.iri}'})").pluck(:a).first
    # TODO String interp in query string is very insecure, fix urgently
  end
  
  # def as_json(options = {})
  #   {
  #     "@id" => self.id,
  #     "@class" => "so:gene",
  #     "symbol" => symbol,
  #     "name" => name,
  #     "hgnc_id" => self.id
  #   }
  # end

end
