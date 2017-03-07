class CurationsController < ApplicationController

  def index
    @genes = Gene.genes_summary
  end

end
