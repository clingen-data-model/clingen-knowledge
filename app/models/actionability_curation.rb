class ActionabilityCuration < Curation

  has_many :in, :interventions, model_class: :ActionabilityInterventionCuration, type: :was_generated_by
  has_many :out, :genes, model_class: :Gene, type: :has_subject
  has_many :out, :conditions, model_class: :Condition, type: :has_object

end
