class ExperimentalEvidence < Entity
  property :description
  
  has_one :out, :type, type: :is_a, model_class: :RDFClass
  has_one :out, :publication, type: :in_publication

  # Evidence types:
  # ECO:0000179: Animal model system study evidence

  def as_json(options={})
    {
      "@id" => self.id,
      "description" => self.description,
      "type" => self.type ? self.type.iri : nil
    }
  end

end
