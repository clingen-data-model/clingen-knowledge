class HomeController < ApplicationController
  def index
    @term = params[:term]
    expires_in 10.minutes, public: true

    if !@term
      @term = params[:'mainSearchCriteria.v.dn']
    end

    ## Passes the term queries to analytics
    @analyticsDimension5  = @term
    @analyticsDimension7  = "KB Home - Index"

    respond_to do |format|
      format.html do
        if @term

          @coord = /chr(\d{1,2}|X|Y):\d+\-\d+/i.match(@term)
          # @coord = "chr15:12641775-84045982"
          if @coord
            @coord = @coord.to_s
            @chr = @coord.split(':').first.upcase.gsub('CHR', '')
            @start = @coord.split(':').last.split('-').first
            @stop = @coord.split(':').last.split('-').last

            # @geneRegionsFound = Neo4j::ActiveBase.current_session.query("
            #   MATCH (g:Gene)-[:has_exon]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '#{@chr}'})
            #   MATCH (r:Region)-[:has_context]->(rc:RegionContext)-[:mapped_on]->(a:Assembly {label: 'GRCh38'})
            #   WHERE (rc.start >= #{@start} AND rc.start <= #{@stop}) OR (rc.stop >= #{@start} AND rc.stop <= #{@stop})
            #   RETURN g.symbol AS symbol, g.name AS name, g.hgnc_id AS hgnc_id, g.last_curated AS last_curated, g.num_curations as num_curations
            #   ORDER BY g.num_curations DESC
            # ").to_a

            @geneRegionsFound = Neo4j::ActiveBase.current_session.query("
              MATCH (g:Gene)-[:has_exon]->(r:Region)-[:has_context]->(rc:RegionContext)
              WHERE ((rc.start >= '#{@start}' AND rc.start <= '#{@stop}')
                OR (rc.stop >= '#{@start}' AND rc.stop <= '#{@stop}'))
              AND split(split(g.location, 'p')[0], 'q')[0] = '#{@chr}'
              RETURN g, MIN(rc.start) AS start, MAX(rc.stop) AS stop
              ORDER BY g.num_curations DESC
            ")
            @loc_data = @geneRegionsFound.map { |r| [r.g.symbol, {'chr': r.g.location.split(/[pq]/).first, 'start': r.start, 'stop': r.stop}] }.to_h
            @geneRegionsFound = @geneRegionsFound.map { |r| r.g }
            @genes = @geneRegionsFound.first(20)

            # a = Gene.all(:g)
            #   .where("(g)-[:has_exon]->(r:Region)-[:has_context]->(rc:RegionContext)")


            # d = Gene.match("(g:Gene)-[:has_exon]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '#{@chr}'})")

            # @variantsFound = Neo4j::ActiveBase.current_session.query("
            #   MATCH (cn:RDFClass)<-[:has_type]-(v:Variation)-[:has_region]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '#{@chr}'})
            #   MATCH (a:Assembly {label: 'GRCh38'})<-[:mapped_on]-(rc:RegionContext)<-[:has_context]-(r:Region)
            #   WHERE (rc.start >= #{@start} AND rc.start <= #{@stop}) OR (rc.stop >= #{@start} AND rc.stop <= #{@stop})
            #   RETURN v.iri AS iri, v.dbvar_id AS dbvar_id, cn.synonym AS variant_type, a.label AS assembly, chr.label AS chr, rc.start AS start, rc.stop AS stop
            # ").to_a

            @variantsFound = Neo4j::ActiveBase.current_session.query("
              MATCH (cn:RDFClass)<-[:has_type]-(v:Variation)-[:has_region]->(r:Region)
                -[:has_context]->(rc:RegionContext {assembly: 'GRCh38', chromosome: '#{@chr}'})
              WHERE (rc.inner_start >= '#{@start}' AND rc.inner_start <= '#{@stop}') OR (rc.inner_stop >= '#{@start}' AND rc.inner_stop <= '#{@stop}')
              RETURN v.iri AS iri, v.dbvar_id AS dbvar_id, cn.synonym AS variant_type, rc.assembly AS assembly, rc.chromosome AS chr, rc.inner_start AS start, rc.inner_stop AS stop
            ").to_a

            @variants = @variantsFound.first(20)

            if @genes.size > 0
              @active_class = :genes
            elsif @variants.size > 0
              @active_class = :variants
            else
              @active_class = :none
            end
            redirect_to @genes.first if @genes && @genes.length == 1 && @variants.length == 0
            redirect_to @variants.first if @variants && @variants.length == 1 && @genes.length == 0

          else
            @genesFound = Gene.find_by_term(@term).order(num_curations: :desc)
            @genes = @genesFound.limit(20)
            @conditionsFound = Condition.find_by_term(@term).order(num_curations: :desc)
            @conditions = @conditionsFound.limit(20)
            @drugsFound = Drug.find_by_term(@term)
            @drugs = @drugsFound.limit(20)

            if @genes.size > 0
              @active_class = :genes
            elsif @conditions.size > 0
              @active_class = :conditions
            elsif @drugs.size > 0
              @active_class = :drugs
            else
              @active_class = :none
            end
          end
          redirect_to @genes.first if @genes && @genes.length == 1 && @conditions.length == 0
          redirect_to @conditions.first if @conditions && @conditions.length == 1 && @genes.length == 0
        end

      end
      format.json do
        # return formatted json for typeahead
        if @term
          search_term = @term.upcase
          @genes = Gene.all(:g).where("g.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          @conditions = Condition.all(:c).where("c.search_label contains {term}")
                          .params(term: search_term).limit(10).to_a
          @drugs = Drug.all(:d).where("d.search_label contains {term}")
                     .params(term: search_term).limit(10).to_a
          terms = @genes + @conditions + @drugs
          @result = terms.map { |t| {label: "#{t.label} (#{t.curie.tr '_', ':'})", url: url_for(t)} }
          render json: @result
        end
      end
    end
  end

end

# chr15:83213988-84714734
#
# MATCH (g:Gene)-[:has_exon]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '15'})
# MATCH (r:Region)-[:has_context]->(rc:RegionContext)-[:mapped_on]->(a:Assembly {label: 'GRCh38'})
# WHERE (rc.start >= 83213988 AND rc.start <= 84714734) OR (rc.stop >= 83213988 AND rc.stop <= 84714734)
# RETURN g, r, chr, rc, a
# LIMIT 1
#
# |SMKD|Danijela Krgovic  Laboratory of Medical Genetics|ISCA site 10|ISCA site 4|10|

# MATCH (v:Variation)-[:has_region]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '15'})
# MATCH (r:Region)-[:has_context]->(rc:RegionContext)-[:mapped_on]->(a:Assembly {label: 'GRCh38'})
# WHERE (rc.start >= 83213988 AND rc.start <= 84714734) OR (rc.stop >= 83213988 AND rc.stop <= 84714734)
# RETURN DISTINCT v
#
# MATCH (cn:RDFClass)<-[:has_type]-(v:Variation)-[:has_region]->(r:Region)<-[:has_member]-(chr:Chromosome {label: '15'})
# MATCH (a:Assembly {label: 'GRCh38'})<-[:mapped_on]-(rc:RegionContext)<-[:has_context]-(r:Region)
# WHERE (rc.start >= 83213988 AND rc.start <= 84714734) OR (rc.stop >= 83213988 AND rc.stop <= 84714734)
# RETURN v.iri, v.dbvar_id, cn.synonym, a.label, chr.label, rc.start, rc.stop
# LIMIT 1

# MATCH (cn:RDFClass)<-[:has_type]-(v:Variation)-[:has_region]->(r:Region)
#   -[:has_context]->(rc:RegionContext {assembly: 'GRCh38', chromosome: '22'})
# WHERE (toInt(rc.inner_start) >= 40000000 AND toInt(rc.inner_start) <= 50000000) OR (toInt(rc.inner_stop) >= 40000000 AND toInt(rc.inner_stop) <= 50000000)
# RETURN v.iri AS iri, v.dbvar_id AS dbvar_id, cn.synonym AS variant_type, rc.assembly AS assembly, rc.chromosome AS chr, rc.inner_start AS start, rc.inner_stop AS stop

# MATCH (g:Gene)-[:has_exon]->(e:Region)-[:has_context]
# ->(rc:RegionContext)
# WHERE rc.chromosome IS NOT NULL
# RETURN g, e, rc
# LIMIT 1
#
# WHERE rc.chromosome IS NOT NULL
# AND rc.assembly IS NOT NULL
#
# MATCH (g:Gene)-[:has_exon]->(r:Region)-[:has_context]->(rc:RegionContext)
# WHERE (rc.start >= 1000000 AND rc.start <= 2000000 OR (rc.stop >= 1000000 AND rc.stop <= 2000000
# RETURN g.symbol AS symbol, g.name AS name, g.hgnc_id AS hgnc_id, g.last_curated AS last_curated, g.num_curations as num_curations, split(split(g.location, 'p')[0], 'q')[0] as chr
# ORDER BY g.num_curations DESC
#
# MATCH (g:Gene)-[:has_exon]->(r:Region)-[:has_context]->(rc:RegionContext)
# RETURN g.symbol AS symbol, g.name AS name, g.hgnc_id AS hgnc_id, g.last_curated AS last_curated, g.num_curations as num_curations, split(split(g.location, 'p')[0], 'q')[0]
# LIMIT 5

# MATCH (g:Gene)-[:has_exon]->(r:Region)-[:has_context]->(rc:RegionContext)
# WHERE ((rc.start >= '82641775' AND rc.start <= '84045982')
#   OR (rc.stop >= '82641775' AND rc.stop <= '84045982'))
# AND split(split(g.location, 'p')[0], 'q')[0] = 15
# RETURN g.symbol AS symbol, g.name AS name, g.hgnc_id AS hgnc_id,
#   g.last_curated AS last_curated, g.num_curations AS num_curations,
#   MIN(rc.start) AS start, MAX(rc.stop) AS stop
# ORDER BY g.num_curations DESC

# MATCH (cn:RDFClass)<-[:has_type]-(v:Variation)-[:has_region]->(r:Region)
#   -[:has_context]->(rc:RegionContext {assembly: 'GRCh38', chromosome: '15'})
# WHERE (rc.inner_start >= '12641775' AND rc.inner_start <= '84045982') OR (rc.inner_stop >= '12641775' AND rc.inner_stop <= '84045982')
# RETURN v.iri AS iri, v.dbvar_id AS dbvar_id, cn.synonym AS variant_type, rc.assembly AS assembly, rc.chromosome AS chr, rc.inner_start AS start, rc.inner_stop AS stop
