class CurationsController < ApplicationController

  def index
    @genes = Gene.genes_summary

    @pageTitle = "ClinGen Curated Genes Summaries"
  end

end
