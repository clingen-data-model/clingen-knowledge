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
    #link_to gene_path(id: gene_record[:hgnc_id]), :class => "btn btn-success btn-xs"  do
    #  "".html_safe + assertion[:short_label]
      ("<a class='btn btn-success btn-xs' target='file' href='https://dosage.clinicalgenome.org/clingen_gene.cgi?sym=" + gene_record[:symbol] + "&subject'> " + assertion[:short_label] + "</a>").html_safe
    #link_to(assertion[:short_label], gene_path(id: gene_record[:hgnc_id]), class: "btn btn-success btn-xs")
  end
end
