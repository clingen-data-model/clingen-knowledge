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
     intervention: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000086",
      evidence: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000042"}[category]
  end

  # TODO innefficient way of representing actionability scores
  # investigate ways for making query more efficient
  def actionability_score(category)
    iri = act_cat_map(category)
    subscore = evidence.query_as(:e)
                 .match("(e)-[:has_predicate]->(i)")
                 .where("(i)-[:subClassOf]->(:RDFClass {iri: '#{iri}'})")
                 .pluck(:i).first.score
    
    e = evidence.query_as(:e)
          .match("(e)-[:has_predicate]->(i)")
          .where("(e)-[:has_predicate]->()-[:subClassOf]->(:RDFClass {iri: '#{iri}'})")
          .where("(i)-[:subClassOf]->(:RDFClass {iri: '#{act_cat_map(:evidence)}'})")
          .pluck(:i).first

    evidence_score = e ? e.score : ""
    subscore + evidence_score
  end

end
