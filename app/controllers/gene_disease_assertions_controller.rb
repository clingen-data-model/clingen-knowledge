class GeneDiseaseAssertionsController < ApplicationController

  include ApplicationHelper

  def index
    expires_in 10.minutes, public: true

    @feedback_tool = "gene-disease"
    
    logger.debug "checkpoint 9"

    # @assertions = GeneDiseaseAssertion.all.limit(200)
    # @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)
    # @assertions = GeneDiseaseAssertion.query_as(:a).return("a {.date, .perm_id, .score_string, genes: [(g:Gene)<-[:has_subject]-(a) | g {.symbol, .hgnc_id}], diseases: [(d:RDFClass)<-[:has_object]-(a) | d {.curie, .label}], interpretation: [(i:Interpretation)<-[:has_predicate]-(a) | i {.label}]}").to_a.map(&:a).sort_by { |r| r[:genes].first[:symbol] }
    @assertions = GeneDiseaseAssertion.query_as(:a)
                    .where("NOT((a)-[:wasInvalidatedBy]->())")
                    .return("a {.date, .perm_id, .score_string, .jsonMessageVersion, .score_string_gci, .score_string_sop5,
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
    
    logger.debug "HELLO checkpoint 9"

    ##render json: @assertion
    if @assertion[:score_string_gci].present?
      @assertionScoreJsonGci = ActiveSupport::JSON.decode(@assertion[:score_string_gci])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJsonGci)
      if @assertion[:jsonMessageVersion] == "GCI.6"
        #@animalmode = (@assertionScoreJsonGci['summary']['FinalClassification'] == 'Limited') \
		#	&& @assertionScoreJsonGci['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Count'] > 0 \
		#	&& @assertionScoreJsonGci['ValidContradictoryEvidence']['Value'] == 'NO'
        @animalmode = print_animal_mode(@assertion[:jsonMessageVersion], @assertionScoreJsonGci, true)
      else
		#@animalmode = (@assertionScoreJsonGci['summary']['FinalClassification'] == 'Limited') \
		#	&& @assertionScoreJsonGci['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		#	&& @assertionScoreJsonGci['ValidContradictoryEvidence']['Value'] == 'NO'
        @animalmode = print_animal_mode(@assertion[:jsonMessageVersion], @assertionScoreJsonGci, true)
	  end
    elsif @assertion[:score_string_sop5].present?
      @assertionScoreJsonSop5 = ActiveSupport::JSON.decode(@assertion[:score_string_sop5])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJsonSop5)
      #@animalmode = (@assertionScoreJsonSop5['scoreJson']['summary']['CalculatedClassification'] == 'Limited') \
		#&& @assertionScoreJsonSop5['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		#&& @assertionScoreJsonSop5['ValidContradictoryEvidence']['Value'] == 'NO'
      @animalmode = print_animal_mode('SOP5', @assertionScoreJsonSop5, true)    
    elsif @assertion[:score_string].present?
      @assertionScoreJson = ActiveSupport::JSON.decode(@assertion[:score_string])
      @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJson)
      #@animalmode = (@assertionScoreJson['data']['FinalClassification'] == 'Limited') \
		#	&& @assertionScoreJson['data']['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		#	&& @assertionScoreJson['data']['ValidContradictoryEvidence']['Value'] == 'NO'
      @animalmode = print_animal_mode('SOP4', @assertionScoreJson, true)
    else
	  @animalmode = false
    end
    #@assertionScoreArray = JSON.parse(assertionScoreJson)
    
    #logger.debug "checkpoint #{@commonscore}"
    
    @pageTitle = "Gene Validity Curation"

    @analyticsDimension7  = "KB Gene Validity - Show"
  end

end
