class Activity
  include Neo4j::ActiveNode

  property :started_at_time, type: DateTime
  property :ended_at_time, type: DateTime

  has_many :in, :generated, type: :wasGeneratedBy
  has_many :out, :used, type: :used
  has_many :out, :associated_with, type: :wasAssociatedWith
end
