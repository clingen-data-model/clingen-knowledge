class ForceCreateAssertionIriConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Assertion, :iri, force: true
  end

  def down
    drop_constraint :Assertion, :iri
  end
end
