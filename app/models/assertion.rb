class Assertion < Entity

  has_many :out, :subjects, model_class: :Entity, type: :has_subject
  has_many :out, :interpretation, model_class: :Interpretation, type: :has_predicate
  has_many :out, :objects, model_class: :Entity, type: :has_object
  has_many :out, :diseases, model_class: :RDFClass, type: :has_object
  has_one :out, :status, model_class: :RDFClass, type: :has_status
  has_many :out, :evidence, model_class: :Entity, type: :has_supporting_evidence

end
