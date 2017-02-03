class Gene
  include Neo4j::ActiveNode
  
  self.mapped_label_name = 'region'

  property :hgnc_id
  property :symbol
  property :name
  property :location

  has_many :in, :assertions, model_class: :Assertion, type: :has_subject


# Grand query matching all actionability scores (given a gene)
# Restricting returns in this query to actionability, but 
# is feasible to do more

# match(g:region {symbol: "TP53"})<-[:has_subject]-(a:Assertion)-[:has_predicate]->(:Class {iri: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000082"})
# return a {.uuid, disease: [(a)-[:has_object]-(d:Class) | d.label],
# interventions: [(a)-[:has_supporting_evidence]->(a2:Assertion)-[:has_object]->(i:Intervention) |
# a2 {intervention: i.label, scores: [(a2)-[:has_supporting_evidence]->(a3:Assertion) | [(a3)-[:has_predicate]->(sp:Class) | sp {.iri, .score} ] ]}]}

  # retrieve actionability scores for a given curation
  def actionability_scores
    assertions.query_as(:a)
      .where("(a)-[:has_predicate]->(:Class {iri: 'http://datamodel.clinicalgenome.org/clingen.owl#CG_000082'})")
      .return("a {.uuid, disease: [(a)-[:has_object]-(d:Class) | d.iri],
 interventions: [(a)-[:has_supporting_evidence]->(a2:Assertion)-[:has_object]->(i:Intervention) |
 a2 {label: i.label, scores: [(a2)-[:has_supporting_evidence]->(a3:Assertion) | [(a3)-[:has_predicate]->(sp:Class)-[:subClassOf]->(super) | sp {.iri, .score} ] ]}]}")
      .to_a.map(&:a)
  end


  def actionability_for_disease(disease)
    assertions.query_as(:a)
      .where('(a)-[:has_predicate]->(:Class {iri: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000082"})').where("(a)-[:has_object]->(:Class {iri: '#{disease.iri}'})").pluck(:a).first
    # TODO String interp in query string is very insecure, fix urgently
  end
  
  def as_json(options = {})
    {
      "@id" => self.id,
      "@class" => "so:gene",
      "symbol" => symbol,
      "name" => name,
      "hgnc_id" => self.id
    }
  end

end
