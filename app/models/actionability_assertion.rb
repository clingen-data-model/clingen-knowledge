class ActionabilityAssertion < Assertion

  property :file
  
  # has_one :out, :curation, model_class: :ActionabilityInterventionCuration, type: :was_generated_by
  has_many :in, :intervention_assertions, model_class: :ActionabilityInterventionAssertion, type: :was_generated_by
  # inherits interpretation from Assertion
  has_one :out, :evidence_strength, model_class: :Interpretation, type: :has_evidence_strength


  def to_param
    perm_id
  end

  def act_cat_map(category)
    {severity: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000041",
     likelihood: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000047",
     effectiveness: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000052",
     intervention: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000086",
     evidence: "http://datamodel.clinicalgenome.org/clingen.owl#CG_000042"}[category]
  end


  def self.act_scores
    {efficacy: {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000061" => 0,
             "http://datamodel.clinicalgenome.org/clingen.owl#CG_000060" => 1,
             "http://datamodel.clinicalgenome.org/clingen.owl#CG_000059" => 2,
             "http://datamodel.clinicalgenome.org/clingen.owl#CG_000058" => 3},
     evidence: {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000057" => "E",
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000056" =>  "D",
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000055" => "C",
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000054" => "B",
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000053" => "A"},
     likelihood: {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000051" => 0,
                  "http://datamodel.clinicalgenome.org/clingen.owl#CG_000050" => 1,
                  "http://datamodel.clinicalgenome.org/clingen.owl#CG_000049" => 2,
                  "http://datamodel.clinicalgenome.org/clingen.owl#CG_000048" => 3},
     severity: {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000046" => 0,
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000045" => 1,
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000044" => 2,
                "http://datamodel.clinicalgenome.org/clingen.owl#CG_000043" => 3},
     safety: {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000089" => 2,
              "http://datamodel.clinicalgenome.org/clingen.owl#CG_000088" => 1,
              "http://datamodel.clinicalgenome.org/clingen.owl#CG_000090" => 0,
              "http://datamodel.clinicalgenome.org/clingen.owl#CG_000087" => 3}}
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
