class Gene
  include Neo4j::ActiveNode
  
  self.mapped_label_name = 'region'

  property :hgnc_id
  property :symbol
  property :name
  property :location

  has_many :in, :assertions, model_class: :Assertion, type: :has_subject

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
