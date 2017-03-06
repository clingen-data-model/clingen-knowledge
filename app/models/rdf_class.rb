class RDFClass
  include Neo4j::ActiveNode

  id_property :iri
  property :label
  property :score
  property :synonym
  property :curie
  property :short_label

  has_many :out, :superclasses, type: :subClassOf, model_class: RDFClass
  has_many :in, :subclasses, type: :subClassOf, model_class: RDFClass


  # def as_json(options = {}) 
  #   {
  #     "@id" => self.id,
  #     "label" => label
  #   }
  # end

  

  # Render json sutiable for rendering experimental evidence options for vue
  # Offer array of category name, with array of id, label assoc
  def self.experimental_evidence_json
    root = self.find("http://clinicalgenome.org/ns/clingen#experimental_evidence")
    result = root.subclasses.
               map {|c| {name: c.label, types: c.subclasses.pluck(:iri, :label)}}
    JSON.pretty_generate(result)
  end

end
