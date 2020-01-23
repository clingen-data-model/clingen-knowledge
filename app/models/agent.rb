class Agent < Entity

  id_property :iri
  has_many :in, :attributions, model_class: :Entity, type: :wasAttributedto

  # retrieve a list of all affiliates and all their curations
  # MATCH (n:Agent) OPTIONAL MATCH (n)--(m) WITH
  #     {agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as query
  #     RETURN query  LIMIT 2000
  def self.gene_diseases
    Agent.query_as(:n)
      .match("(n:Agent)")
      .optional_match("(n)--(m)")
      .with("{agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as data")
      .return("data")
      .order("data.agent")
      #.to_a
      #.map(&:n)
  end
  
  # retrieve a specific affliate with their list of curations
  def self.gene_diseases_item(vcep)
  
	url = "https://search.clinicalgenome.org/kb/agents/" + vcep
	
    Agent.query_as(:n)
      .match("(n:Agent { iri: {vcep} })")
      .params(vcep: url)
      .optional_match("(n)--(m)")
      .where("NOT((m)-[:wasInvalidatedBy]->())")
      .return("n.iri as agent, n.label as label, collect(m) as curations")
      #.with("{agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as data")
      #.return("data")
      #.to_a
      #.map(&:n)
  end
  
  # retrieve list of affiliates along with their curation counts
  def self.gene_diseases_count
    Agent.query_as(:n)
      .match("(n:Agent)")
      .optional_match("(n)--(m)")
      .where("NOT((m)-[:wasInvalidatedBy]->())")
      .return("n.iri as agent, n.label as label, count(m) as count")
      .order("agent")
      #.to_a
      #.map(&:n)
  end
  
end