class SubscriptionsController < ApplicationController

  def create
    if params[:id] =~ /$HGNC/
      current_agent.subscribed_genes << Gene.find_by(hgnc_id: params[:id])
    else
      current_agent.subscribed_conditions << Condition.find_by(curie: params[:id])
    end
    redirect_to :back
  end

  def destroy
    if params[:id] =~ /$HGNC/
      current_agent.subscribed_genes.delete(Gene.find_by(hgnc_id: params[:id]))
    else
      current_agent.subscribed_conditions.delete(Condition.find_by(curie: params[:id]))
    end
    redirect_to :back
  end

end
