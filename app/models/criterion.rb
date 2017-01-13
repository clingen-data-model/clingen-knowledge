class Criterion
  include Neo4j::ActiveNode
  property :category_max, type: Float
  property :min, type: Float
  property :max, type: Float
  property :default, type: Float
  property :description, type: String

  has_many :out, :parents, type: :isA, model_class: Criterion
  has_many :in, :children, type: :isA, model_class: Criterion

  # TODO write import script from YAML initialization data
  
end
