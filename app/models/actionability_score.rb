class ActionabilityScore < Assertion

  def self.score_map
    {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000061" => [:efficacy, 0],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000060" => [:efficacy, 1],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000059" => [:efficacy, 2],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000058" => [:efficacy, 3],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000051" => [:likelihood, 0],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000050" => [:likelihood, 1],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000049" => [:likelihood, 2],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000048" => [:likelihood, 3],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000046" => [:severity, 0],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000045" => [:severity, 1],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000044" => [:severity, 2],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000043" => [:severity, 3],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000089" => [:safety, 2],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000088" => [:safety, 1],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000090" => [:safety, 0],
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000087" => [:safety, 3]}
  end


  def self.evidence_map
    {"http://datamodel.clinicalgenome.org/clingen.owl#CG_000057" => "E",
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000056" =>  "D",
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000055" => "C",
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000054" => "B",
     "http://datamodel.clinicalgenome.org/clingen.owl#CG_000053" => "A"}
  end

  # Map the IRI based format of scores to a hash with text scores
  def self.scores_to_h(scores)
    total = 0
    total_evidence = ""
    result = scores.reduce({}) do |h, i|
      e = i[:strength].length > 0 ? ActionabilityScore.evidence_map[i[:strength].first] : ""
      s = ActionabilityScore.score_map[i[:score].first]
      # Side effects in a reduce block--probably not kosher, but works
      total += s.second
      total_evidence += e
      h.update(s.first => s.second.to_s + e)
    end
    result.update(total: total.to_s + total_evidence)
  end
end 
