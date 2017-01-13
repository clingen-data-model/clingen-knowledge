class StudyCase < Entity

  property :label, type: String
  property :age, type: Integer
  property :sex, type: String
  property :segregations, type: Integer
  
  has_many :out, :phenotypes, type: :has_phenotype, model_class: :RDFClass
  has_many :out, :variants, type: :has_variant, model_class: :Allele
  has_many :out, :denovo_variants, type: :has_denovo_variant, model_class: :Allele
  has_one :out, :publication, type: :in_publication

  def as_json(options = {})
    {
      "@id" => self.id,
      "@type" => "cg:study_case",
      "label" => self.label,
      "age" => self.age,
      "sex" => self.sex,
      "segregations" => self.segregations,
      "phenotypes" => self.phenotypes || [],
      "variants" => self.variants || []
    }
  end

end
