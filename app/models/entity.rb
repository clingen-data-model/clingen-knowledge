class Entity
  include Neo4j::ActiveNode

  property :date
  property :label
  property :description
  property :perm_id

  def self.type_class_map
    {
      "cg:publication" => Publication,
      "cg:study_case" => StudyCase,
      "cg:case_control_study" => CaseControlStudy,
      "cg:experimental_evidence" => ExperimentalEvidence
    }
  end

end
