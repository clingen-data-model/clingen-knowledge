class ActionabilityOutcomeAssertion < Assertion

  has_many :in, :intervention_assertions, model_class: :ActionabilityInterventionAssertion, type: :has_subject

end

