class Interpretation < Entity

  has_one :out, :generated_by, model_class: :Activity, type: :wasGeneratedBy
  has_one :out, :mode_of_inheritance, type: :mode_of_inheritance, model_class: "RDFClass"
  has_one :out, :gene, type: :gene
  has_many :out, :publications, type: :uses_publication
  has_one :out, :disease, type: :disease, model_class: "RDFClass"

  # Only use direct subclasses of mode_of_inheritance
  def self.modes_of_inheritance
    RDFClass.find('http://purl.obolibrary.org/obo/HP_0000005').subclasses
  end

  def as_json(options = {})
    {
      "@id" => self.id,
      "@class" => "cg:gene_interpretation",
      "gene" => gene,
      "disease" => disease,
      "mode_of_inheritance" => mode_of_inheritance,
      "publications" => publications || []
    }
  end
  
end
