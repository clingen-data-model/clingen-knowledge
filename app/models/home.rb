class Home
  include Neo4j::ActiveNode
  
  self.mapped_label_name = 'region'

  id_property :hgnc_id
  property :symbol, index: :exact
  property :name, index: :exact
  
  def as_json(options = {})
    {
      "@id" => self.id,
      "@class" => "so:gene",
      "symbol" => symbol,
      "name" => name,
      "hgnc_id" => self.id
    }
  end

end
