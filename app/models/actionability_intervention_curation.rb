class ActionabilityInterventionCuration < Curation

  has_one :out, :curation, model_class: :ActionabilityCuration, type: :was_generated_by
  has_one :out, :intervention, model_class: :Intervention, type: :has_object
  has_many :in, :assertions, model_class: :ActionabilityAssertion, type: :was_generated_by
  # Will need to add freeform 'condition' to this, possibly as a label
  # until there are propery typed entities

end
