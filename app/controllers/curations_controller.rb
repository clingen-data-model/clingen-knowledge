class CurationsController < ApplicationController

  def index
    @genes = Gene.genes_summary

    @pageTitle = "ClinGen Curated Genes Summaries"


    @analyticsDimension7  = "KB Curations - Index"
  end

end
