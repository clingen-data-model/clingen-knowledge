class ActionabilityCuration < Curation

  has_many :out, :interventions, model_class: :ActionabilityInterventionCuration, type: :hadMember
  has_many :out, :genes, model_class: :Gene, type: :hadMember
  has_many :out, :conditions, model_class: :Condition, type: :hadMember

end
