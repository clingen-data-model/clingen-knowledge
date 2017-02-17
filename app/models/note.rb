class Note   
 include Neo4j::ActiveNode

  property :gene
  property :omim
  property :orphanet
  property :publication
  property :comments

  
end