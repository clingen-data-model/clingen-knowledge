class Publication < Entity
  
  property :pmid
  property :title
  property :first_author
  property :authors_abbrev

  # has_many :in, :study_cases, type: :in_publication
  # has_many :in, :case_control_studies, type: :in_publication
  # has_many :in, :experimental_evidence, type: :in_publication
  # has_many :in, :evidence, type: :wasDerivedFrom
  # has_one :in, :interpretation, type: :uses_publication

  # validate :confirm_pmid

  def as_json(options = {})
    {
      "@id" => self.id,
      "@type" => "cg:publication",
      "pmid" => pmid,
      "title" => title,
      "first_author" => first_author,
      "study_cases" => study_cases || [],
      "case_control_studies" => case_control_studies || [],
      "experimental_evidence" => experimental_evidence || []
    }
  end

  protected

  # Validate format of and lookup pmid in PubMed
  def confirm_pmid
    # Confirm format of pmid
    unless pmid && /\d+/.match(pmid)
      errors.add(:pmid, 'must be numeric')
      return false
    end
    rest_response = RestClient.get(
      'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi',
      params: {db: 'pubmed', id: pmid, format: 'json'}
    )
    unless rest_response.code == 200
      errors.add(:pmid, 'error contacting NCBI')
      return false
    end
    response = JSON.parse(rest_response.body)
    article = response['result'][pmid]
    unless article
      errors.add(:pmid, 'not found in PubMed')
      return false
    end
    # Assign title and author while we have them...
    self.title = article['title']
    self.first_author = article['sortfirstauthor']
  end

end
