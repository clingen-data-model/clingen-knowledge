class Criterion
  include Neo4j::ActiveNode
  property :category_max
  property :min
  property :max
  property :default
  property :description

  has_many :out, :parents, type: :isA, model_class: Criterion
  has_many :in, :children, type: :isA, model_class: Criterion

  # TODO write import script from YAML initialization data
  
end
