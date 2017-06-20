class ActionabilityScore < Assertion

  # TODO, these should be pulled from the database, rather than
  # hardcoded in the model

  def self.score_map
    {"http://datamodel.clinicalgenome.org/terms/CG_000061" => [:efficacy, 0],
     "http://datamodel.clinicalgenome.org/terms/CG_000060" => [:efficacy, 1],
     "http://datamodel.clinicalgenome.org/terms/CG_000059" => [:efficacy, 2],
     "http://datamodel.clinicalgenome.org/terms/CG_000058" => [:efficacy, 3],
     "http://datamodel.clinicalgenome.org/terms/CG_000051" => [:likelihood, 0],
     "http://datamodel.clinicalgenome.org/terms/CG_000050" => [:likelihood, 1],
     "http://datamodel.clinicalgenome.org/terms/CG_000049" => [:likelihood, 2],
     "http://datamodel.clinicalgenome.org/terms/CG_000048" => [:likelihood, 3],
     "http://datamodel.clinicalgenome.org/terms/CG_000046" => [:severity, 0],
     "http://datamodel.clinicalgenome.org/terms/CG_000045" => [:severity, 1],
     "http://datamodel.clinicalgenome.org/terms/CG_000044" => [:severity, 2],
     "http://datamodel.clinicalgenome.org/terms/CG_000043" => [:severity, 3],
     "http://datamodel.clinicalgenome.org/terms/CG_000089" => [:safety, 2],
     "http://datamodel.clinicalgenome.org/terms/CG_000088" => [:safety, 1],
     "http://datamodel.clinicalgenome.org/terms/CG_000090" => [:safety, 0],
     "http://datamodel.clinicalgenome.org/terms/CG_000087" => [:safety, 3]}
  end

  def self.label_map
    {"http://datamodel.clinicalgenome.org/terms/CG_000061" => [:efficacy, "Ineffective/No Intervention"],
     "http://datamodel.clinicalgenome.org/terms/CG_000060" => [:efficacy, "Minimally Effective"],
     "http://datamodel.clinicalgenome.org/terms/CG_000059" => [:efficacy, "Moderately Effective"],
     "http://datamodel.clinicalgenome.org/terms/CG_000058" => [:efficacy, "Highly Effective"],
     "http://datamodel.clinicalgenome.org/terms/CG_000051" => [:likelihood, "<1% chance or unknown"],
     "http://datamodel.clinicalgenome.org/terms/CG_000050" => [:likelihood, "1-4% chance"],
     "http://datamodel.clinicalgenome.org/terms/CG_000049" => [:likelihood, "5-39% Chance"],
     "http://datamodel.clinicalgenome.org/terms/CG_000048" => [:likelihood, ">40% Chance"],
     "http://datamodel.clinicalgenome.org/terms/CG_000046" => [:severity, "Minimal or no Morbidity"],
     "http://datamodel.clinicalgenome.org/terms/CG_000045" => [:severity, "Modest Morbidity"],
     "http://datamodel.clinicalgenome.org/terms/CG_000044" => [:severity, "Possible death or Major Morbidity"],
     "http://datamodel.clinicalgenome.org/terms/CG_000043" => [:severity, "Sudden Death"],
     "http://datamodel.clinicalgenome.org/terms/CG_000089" => [:safety, "Greater Risk"],
     "http://datamodel.clinicalgenome.org/terms/CG_000088" => [:safety, "Moderate Risk"],
     "http://datamodel.clinicalgenome.org/terms/CG_000090" => [:safety, "High Risk"],
     "http://datamodel.clinicalgenome.org/terms/CG_000087" => [:safety, "Low Risk"]}
  end


  def self.evidence_map
    {"http://datamodel.clinicalgenome.org/terms/CG_000057" => "E",
     "http://datamodel.clinicalgenome.org/terms/CG_000056" =>  "D",
     "http://datamodel.clinicalgenome.org/terms/CG_000055" => "C",
     "http://datamodel.clinicalgenome.org/terms/CG_000054" => "B",
     "http://datamodel.clinicalgenome.org/terms/CG_000053" => "A"}
  end

  def self.evidence_map_label
    {"http://datamodel.clinicalgenome.org/terms/CG_000057" => " (expert contributed evidence)",
     "http://datamodel.clinicalgenome.org/terms/CG_000056" => " (poor or conflicting evidence)",
     "http://datamodel.clinicalgenome.org/terms/CG_000055" => " (minimal evidence)",
     "http://datamodel.clinicalgenome.org/terms/CG_000054" => " (moderate evidence)",
     "http://datamodel.clinicalgenome.org/terms/CG_000053" => " (substantial evidence)"}
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
  def self.labels_to_h(scores)
    total = 0
    result = scores.reduce({}) do |h, i|
      s = ActionabilityScore.label_map[i[:score].first]      
      e = i[:strength].length > 0 ? ActionabilityScore.evidence_map_label[i[:strength].first] : ""
      h.update(s.first => s.second.to_s + e)
    end
    result.update(total: total.to_s)
  end
end 
