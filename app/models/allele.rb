class Allele
  include Neo4j::ActiveNode
  property :hgvs, type: String
  property :allele_registry_id, type: String, index: :exact

  has_many :in, :study_cases, type: :has_variant
  has_many :in, :case_control_studies, type: :has_variant
  
  #   validate :identify_variant

  # has_many :in, :study_cases, type: :has_variant
  # has_many :in, :denovo_study_cases, type: :has_denovo_variant, model_class: Case
  # has_one :out, :functional_consequence, type: :isA, model_class: RDFClass

  protected

  def identify_variant
    rest_response = RestClient.get("http://#{ENV['ALLELE_REGISTRY_HOST']}/allele",
                                   params: {hgvs: self.hgvs})
    unless rest_response.code == 200
      errors.add(:hgvs, 'error contacting ClinGen Allele Registry')
      return false
    end
    response = JSON.parse(rest_response.body)
    unless response['@id']
      errors.add(:hgvs, 'allele registry unable to register allele')
    end
    self.allele_registry_id = response['@id']
  end

end
