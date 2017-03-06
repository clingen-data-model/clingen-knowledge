class Note 
  include Neo4j::ActiveNode

  property :comments

  has_one :out, :gene, type: :has_subject, model_class: :Gene
  has_one :out, :condition, type: :has_object, model_class: :Condition
  has_one :out, :publication, type: :was_derived_from, model_class: :Publication


end
