class CaseControlStudy < Entity
 
  property :control_description
  property :power
  property :confounding_factor_description
  property :statistical_signifiance
  
  has_one :out, :study_type, type: :is_a
  has_one :out, :detection_method, type: :uses_detection_method
  has_many :out, :alleles, type: :has_alleles
  has_one :out, :publication, type: :in_publication
  
  def as_json(options = {})
    {
      "@id" => self.id,
      "control_description" => self.control_description,
      "power" => self.power,
      "confounding_factor_description" => self.confounding_factor_description,
      "statistical_signifiance" => self.statistical_signifiance,
      "variants" => self.alleles || []
    }
  end
  
end
