class CurationsController < ApplicationController

  def index
    expires_in 10.minutes, public: true
    @genes = Gene.genes_summary

    @pageTitle = "ClinGen Curated Genes Summaries"


    @analyticsDimension7  = "KB Curations - Index"
  end

end
