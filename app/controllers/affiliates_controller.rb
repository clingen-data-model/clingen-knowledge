class AffiliatesController < ApplicationController
  
  def all
		expires_in 10.minutes, public: true
		
        # @affiliates = Agent.all()
        # Match (n:Agent) optional match (n)--(m) 
        # WITH {agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as query RETURN query  LIMIT 2000
        affiliates = Agent.gene_diseases
        render json: affiliates
  end
  
  def index
		expires_in 10.minutes, public: true
		
        # @affiliates = Agent.all()
        # Match (n:Agent) optional match (n)--(m) 
        # WITH {agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as query RETURN query  LIMIT 2000
        
        #Neo4j::ActiveBase.current_session.query('MATCH (n) RETURN n LIMIT {limit}', limit: 10)

        affiliates = Agent.gene_diseases_count
        
        logger.debug "checkpoint #{affiliates}"
        
        render json: affiliates
  end
  
  def show
		expires_in 10.minutes, public: true
		
        # @affiliates = Agent.all()
        # Match (n:Agent) optional match (n)--(m) 
        # WITH {agent:n.iri,label:n.label,GeneDiseaseAssertions:collect(m) } as query RETURN query  LIMIT 2000
        affiliates = Agent.gene_diseases_item(params[:id])
        render json: affiliates
  end

end
