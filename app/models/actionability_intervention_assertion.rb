class ActionabilityInterventionAssertion < Assertion
  has_many :out, :interventions, model_class: :Intervention, type: :has_object
end
