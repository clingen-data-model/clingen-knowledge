class ActionabilityInterventionCuration < Curation

  has_one :in, :curation, model_class: :ActionabilityCuration, type: :has_member
  has_one :out, :intervention, model_class: :Intervention, type: :has_member
  has_many :out, :assertions, model_class: :ActionabilityAssertion, type: :has_member
  # Will need to add freeform 'condition' to this, possibly as a label
  # until there are propery typed entities

end
