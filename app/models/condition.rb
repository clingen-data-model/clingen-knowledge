class Condition
  include Neo4j::ActiveNode
  
  self.mapped_label_name = 'RDFClass'

  # property :label
  # property :iri
  # property :definition
  # property :synonym

end
