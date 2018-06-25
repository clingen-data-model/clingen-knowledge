class Agent < Entity

  id_property :iri
  has_many :in, :attributions, model_class: :Entity, type: :wasAttributedto

end
