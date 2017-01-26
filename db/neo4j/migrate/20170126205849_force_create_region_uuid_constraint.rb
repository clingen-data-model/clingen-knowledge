class ForceCreateRegionUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :region, :uuid, force: true
  end

  def down
    drop_constraint :region, :uuid
  end
end
