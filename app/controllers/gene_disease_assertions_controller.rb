class GeneDiseaseAssertionsController < ApplicationController

  include ApplicationHelper

  def index
    expires_in 10.minutes, public: true

    @feedback_tool = "gene-disease"

    # @assertions = GeneDiseaseAssertion.all.limit(200)
    # @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)
    # @assertions = GeneDiseaseAssertion.query_as(:a).return("a {.date, .perm_id, .score_string, genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}], diseases: [(d:RDFClass)<-[:has_object]-(a) | d {.curie, .label}], interpretation: [(i:Interpretation)<-[:has_predicate]-(a) | i {.label}]}").to_a.map(&:a).sort_by { |r| r[:genes].first[:symbol] }
    @assertions = GeneDiseaseAssertion.query_as(:a)
                    .where("NOT((a)-[:wasInvalidatedBy]->())")
                    .return("a {.date, .perm_id, .score_string, .jsonMessageVersion, .score_string_gci,
                             genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}],
                             diseases: [(d:DiseaseConcept)-[:has_object|:equivalentClass*1..2]-(a) | d {.curie, .label}],
                             interpretation: [(i:Interpretation)<-[:has_predicate]-(a) | i {.label}],
                             agent: [(ag:Agent)<-[:wasAttributedto]-(a) | ag {.label}]}")
                    .to_a
                    .map(&:a)
                    .sort_by { |r| r[:genes].first[:symbol] }



    @csv_string = CSV.generate do |csv|
      csv.add_row ["CLINGEN GENE VALIDITY CURATIONS"]
      csv.add_row ["FILE CREATED: #{Date.today}"]
      csv.add_row ["WEBPAGE: #{gene_disease_assertions_url}"]
      csv.add_row ["+++++++++++","++++++++++++++","+++++++++++++","++++++++++++++++++","+++++++++","++++++++++++++","+++++++++++++","+++++++++++++++++++"]
      csv.add_row ["GENE SYMBOL","GENE ID (HGNC)","DISEASE LABEL","DISEASE ID (MONDO)","SOP","CLASSIFICATION","ONLINE REPORT","CLASSIFICATION DATE"]
      csv.add_row ["+++++++++++","++++++++++++++","+++++++++++++","++++++++++++++++++","+++++++++","++++++++++++++","+++++++++++++","+++++++++++++++++++"]
      @assertions.each do |a|

        csv << [
          a[:genes].first[:symbol],
          a[:genes].first[:hgnc_id],
          a[:diseases].first[:label],
          a[:diseases].first[:curie],
          gci_SOP(a[:jsonMessageVersion]),
          a[:interpretation].first[:label],
          gene_disease_assertions_url+"/"+a[:perm_id],
          a[:date]
        ]
        #csv << hash
      end
    end


    respond_to do |format|
      format.html
      format.csv { send_data @csv_string, filename: "ClinGen-Gene-Disease-Summary-#{Date.today}.csv" }
    end
    @pageTitle = "Gene Validity Curations"

    @analyticsDimension7  = "KB Gene Validity - Index"
  end

  def show
    expires_in 10.minutes, public: true
    @feedback_tool = "gene-disease"

    @assertion = GeneDiseaseAssertion.find_by(perm_id: params[:id])
    @geneSymbol = @assertion.genes.first.symbol
    @diseaseName = @assertion.diseases.first.label
    @geneCurie = @assertion.genes.first.curie
    @diseaseCurie = @assertion.diseases.first.curie
    

    ##render json: @assertion
    if @assertion[:score_string_gci].present?
      @assertionScoreJsonGci = ActiveSupport::JSON.decode(@assertion[:score_string_gci])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJsonGci)
    elsif @assertion[:score_string_sop5].present?
      @assertionScoreJsonSop5 = ActiveSupport::JSON.decode(@assertion[:score_string_sop5])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJsonSop5)
    elsif @assertion[:score_string].present?
      @assertionScoreJson = ActiveSupport::JSON.decode(@assertion[:score_string])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJson)
    end
    #@assertionScoreArray = JSON.parse(assertionScoreJson)

    @pageTitle = "Gene Validity Curation"

    @analyticsDimension7  = "KB Gene Validity - Show"
  end

end
