class GeneDosageAssertion < Assertion

  def to_param
    perm_id
  end

  def haplo_assertion? 
    GeneDosageAssertion.haplo_iris.include?(interpretation.first.iri)
  end

  def triplo_assertion?
    GeneDosageAssertion.triplo_iris.include?(interpretation.first.iri)
  end

  def self.haplo_iris
    # http://datamodel.clinicalgenome.org/terms/CG_000102
    @@haplo_iris ||= Interpretation.all(:i).where("(i)-[:subClassOf]->(:Interpretation {iri: 'http://datamodel.clinicalgenome.org/terms/CG_000102'})").map { |i| i.iri}
  end

  def self.triplo_iris
    # http://datamodel.clinicalgenome.org/terms/CG_000101
    @@triplo_iris ||= Interpretation.all(:i).where("(i)-[:subClassOf]->(:Interpretation {iri: 'http://datamodel.clinicalgenome.org/terms/CG_000101'})").map { |i| i.iri}
  end

end
