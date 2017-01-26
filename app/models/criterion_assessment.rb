class CriterionAssessment
  include Neo4j::ActiveNode

  property :score
  property :comments

  has_one :out, :criterion, type: :assessed_criterion
  has_one :out, :activity, type: :wasGeneratedBy
  
end
