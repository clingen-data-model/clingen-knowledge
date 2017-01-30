class Assertion < Entity

  property :score_string

  has_many :out, :subjects, model_class: :Entity, type: :has_subject
  has_many :out, :predicates, model_class: :Interpretation, type: :has_predicate
  has_many :out, :objects, model_class: :Entity, type: :has_object
  has_many :out, :diseases, model_class: :RDFClass, type: :has_object
  has_one :out, :status, model_class: :RDFClass, type: :has_status

  has_many :out, :evidence, model_class: :Entity, type: :has_supporting_evidence

  def act_cat_map(category)
    {severity: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000041",
     likelihood: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000047",
     effectiveness: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000052",
     intervention: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000086"}[category]
  end
  
  def actionability_score(category)
    iri = act_cat_map(category)
    # TODO start here and finish represenation of actionability score
    evidence.query_as(:e).match("(e)-[:has_predicate]->(i)").where("(i)-[:subClassOf]->")
  end

end
