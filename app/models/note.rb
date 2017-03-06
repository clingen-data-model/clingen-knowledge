class Note 
  include Neo4j::ActiveNode

  include Neo4j::Timestamps

  property :pmid
  property :gene
  property :condition

  property :case_variant
  property :case_segregation
  property :case_summary

  property :case_control_single_variant
  property :case_control_aggregate_variant
  property :case_control_summary

  property :experimental_function
  property :experimental_function_alteration
  property :experimental_model
  property :experimental_summary

  property :comments

  property :deleted

  has_one :out, :creator, type: :was_generated_by, model_class: :Agent

  # has_one :out, :gene, type: :has_subject, model_class: :Gene
  # has_one :out, :condition, type: :has_object, model_class: :Condition
  # has_one :out, :publication, type: :was_derived_from, model_class: :Publication

end
