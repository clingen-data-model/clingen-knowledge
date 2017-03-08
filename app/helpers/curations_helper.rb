module CurationsHelper
  # Return a link to the given gene with the text of the haplo assertion or a blank string 
  def dosage_summary_link(type, gene_record)
    return "" if gene_record[:dosage].blank?
    if type == :haplo
      iris = GeneDosageAssertion.haplo_iris
    else
      iris = GeneDosageAssertion.triplo_iris
    end
    assertion = gene_record[:dosage].select { |a| iris.include?(a[:iri])}.first
    return "" unless assertion
    link_to gene_path(id: gene_record[:hgnc_id]), :class => "btn btn-success btn-xs"  do
      "<i class=\"glyphicon glyphicon-info-sign text-white\"></i> ".html_safe + assertion[:short_label]
    end
    #link_to(assertion[:short_label], gene_path(id: gene_record[:hgnc_id]), class: "btn btn-success btn-xs")
  end
end
