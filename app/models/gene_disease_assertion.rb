class GeneDiseaseAssertion < Assertion

  def to_param
    perm_id
  end

  # Holds data needed to render JSON assertion for gene dosage
  property :score_string
end
