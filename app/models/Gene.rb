class Gene
  include Neo4j::ActiveNode
  
  property :symbol
  property :name

end
