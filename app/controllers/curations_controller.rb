class CurationsController < ApplicationController

  def index
    expires_in 4.hours, public: true
    @genes = Gene.genes_summary

    @pageTitle = "ClinGen Curated Genes Summaries"


    @analyticsDimension7  = "KB Curations - Index"
  end

end
