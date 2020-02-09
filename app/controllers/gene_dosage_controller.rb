class GeneDosageController < ApplicationController

  def index
    expires_in 60.minutes, public: true

    page = params[:page] || 1
    # @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)

    #@genes = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)")
    #           .with_associations(:dosage_assertions).page(page).per(20)

    # @assertions = GeneDosageAssertion.all.limit(100).page(page).per(20)

    @query = Gene.all(:g).where("(g)<-[:has_subject]-(:GeneDosageAssertion)").order('g.symbol')
    @genes = @query.page(page).per(100)
  
    @pageTitle = "Gene Dosage Curations"

    @analyticsDimension7  = "KB Gene Dosage - Index"
    
    respond_to do |format|
      format.html
      format.csv do 
        @allgenes = @query.page(page).per(5000)
        @csv_string = CSV.generate do |csv|
        csv.add_row ["CLINGEN DOSAGE SENSITIVITY CURATIONS"]
        csv.add_row ["FILE CREATED: #{Date.today}"]
        csv.add_row ["WEBPAGE: #{gene_dosage_index_url}"]
        csv.add_row ["+++++++++++","++++++++++++++++++","+++++++++++++++++","+++++++++++++","++++"]
        csv.add_row ["GENE SYMBOL","HAPLOINSUFFICIENCY","TRIPLOSENSITIVITY","ONLINE REPORT","DATE"]
        csv.add_row ["+++++++++++","++++++++++++++++++","+++++++++++++++++","+++++++++++++","++++"]
        @allgenes.each do |g|
          csv << [
            g.label,
            if a = g.dosage_assertions.select {|i| i.haplo_assertion?}.first
              a.interpretation.first.label
            end,
            if a = g.dosage_assertions.select {|i| i.triplo_assertion?}.first
              a.interpretation.first.label
            end,
            "https://dosage.clinicalgenome.org/clingen_gene.cgi?sym=#{g.label}&subject=",
              g.dosage_assertions.first.date
            ]
            #csv << hash
          end
        end
        send_data @csv_string, filename: "ClinGen-Dosage-Sensitivity-#{Date.today}.csv" 
      end
    end


  end

end
