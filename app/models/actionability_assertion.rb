class ActionabilityAssertion < Assertion

  property :file

  # has_one :out, :curation, model_class: :ActionabilityInterventionCuration, type: :was_generated_by
  has_many :in, :intervention_assertions, model_class: :ActionabilityInterventionAssertion, type: :was_generated_by
  # inherits interpretation from Assertion
  has_one :out, :evidence_strength, model_class: :Interpretation, type: :has_evidence_strength


  def to_param
    perm_id
  end

  def self.act_cat_map(category)
    {severity: "http://datamodel.clinicalgenome.org/terms/CG_000041",
     likelihood: "http://datamodel.clinicalgenome.org/terms/CG_000047",
     effectiveness: "http://datamodel.clinicalgenome.org/terms/CG_000052",
     intervention: "http://datamodel.clinicalgenome.org/terms/CG_000086",
     evidence: "http://datamodel.clinicalgenome.org/terms/CG_000042"}[category]
  end


  def self.act_scores
    {efficacy: {"http://datamodel.clinicalgenome.org/terms/CG_000061" => 0,
                "http://datamodel.clinicalgenome.org/terms/CG_000060" => 1,
                "http://datamodel.clinicalgenome.org/terms/CG_000059" => 2,
                "http://datamodel.clinicalgenome.org/terms/CG_000058" => 3},
     evidence: {"http://datamodel.clinicalgenome.org/terms/CG_000057" => "E",
                "http://datamodel.clinicalgenome.org/terms/CG_000056" =>  "D",
                "http://datamodel.clinicalgenome.org/terms/CG_000055" => "C",
                "http://datamodel.clinicalgenome.org/terms/CG_000054" => "B",
                "http://datamodel.clinicalgenome.org/terms/CG_000053" => "A"},
     likelihood: {"http://datamodel.clinicalgenome.org/terms/CG_000051" => 0,
                  "http://datamodel.clinicalgenome.org/terms/CG_000050" => 1,
                  "http://datamodel.clinicalgenome.org/terms/CG_000049" => 2,
                  "http://datamodel.clinicalgenome.org/terms/CG_000048" => 3},
     severity: {"http://datamodel.clinicalgenome.org/terms/CG_000046" => 0,
                "http://datamodel.clinicalgenome.org/terms/CG_000045" => 1,
                "http://datamodel.clinicalgenome.org/terms/CG_000044" => 2,
                "http://datamodel.clinicalgenome.org/terms/CG_000043" => 3},
     safety: {"http://datamodel.clinicalgenome.org/terms/CG_000089" => 2,
              "http://datamodel.clinicalgenome.org/terms/CG_000088" => 1,
              "http://datamodel.clinicalgenome.org/terms/CG_000090" => 0,
              "http://datamodel.clinicalgenome.org/terms/CG_000087" => 3}}
  end

end
