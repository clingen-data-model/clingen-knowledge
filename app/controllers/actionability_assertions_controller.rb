class ActionabilityAssertionsController < ApplicationController

  def index

    redirect_back fallback_location: "https://www.clinicalgenome.org/curation-activities/clinical-actionability/browse-curations/"

    # expires_in 10.minutes, public: true

    # @pageTitle = "Clinical Actionability Curations";
    # @page = params[:page] || 1
    # # @assertions = ActionabilityAssertion.all.with_associations(:genes, :diseases, :intervention_assertions).page(@page).per(20)
    # @assertions = helpers.index_list(@page)
    
    # @getgenes = Gene.all(:g).where("(g)<-[:has_subject]-(:ActionabilityAssertion)").order('g.symbol')

    # @csv_string = CSV.generate do |csv|
    #   csv.add_row ["CLINGEN CLINICAL ACTIONABILITY CURATIONS"]
    #   csv.add_row ["FILE CREATED: #{Date.today}"]
    #   csv.add_row ["WEBPAGE: #{actionability_assertions_url}"]
    #   csv.add_row ["+++++++++++","+++++++++","+++++++++++++","++++"]
    #   csv.add_row ["GENE SYMBOL","CONDITION","ONLINE REPORT","DATE"]
    #   csv.add_row ["+++++++++++","+++++++++","+++++++++++++","++++"]
    #   @assertions.each do |a|

    #     @genes      = ""
    #     @conditions = ""

    #     a[:genes].each do |g|
    #       @genes += g[:symbol]+",\n"
    #     end
    #     a[:conditions].each do |c|
    #       @conditions += c[:label]+",\n"
    #     end

    #     csv << [
    #       @genes.chop.chop,
    #       @conditions.chop.chop,
    #       a[:report],
    #       a[:date]
    #     ]
    #     #csv << hash
    #   end
    # end

    # @analyticsDimension7  = "KB Actionability Curations - Listing"

    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @csv_string, filename: "ClinGen-Clinical-Actionability-#{Date.today}.csv" }
    # end

  end

  def show
    @actionability = ActionabilityAssertion.find_by(perm_id: params[:id])
  	redirect_to @actionability.file
  end

end
