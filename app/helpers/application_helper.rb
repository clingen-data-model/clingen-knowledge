# coding: utf-8
module ApplicationHelper

  def pageTitle(title)
    if(title)
      title + " - ClinGen Knowledge Base | Clinical Genome Resource"
    else
      "ClinGen Knowledge Base | Clinical Genome Resource"
    end
  end

  def mdy_date(date)
    return "" unless date.instance_of?(String)
    Date.parse(date).strftime('%m/%d/%Y')
  end

  ##	Function:  print_animal_mode
  ##
  ##  	Determine if curation is an animal mode only.  There are four
  ##	distinct score formats in Neo4j.  The 'type' parameter instructs
  ##	the function which format to use.  The 'isjson' flag tells the
  ##	function that 'score' has already been converted to json. 
  ##	
  ##  
  def print_animal_mode(type, score, isjson)
    # if score.present?
	  # if isjson
		# jsonD = score
	  # else
    #     jsonD = ActiveSupport::JSON.decode(score)
    #   end

    #   if type == "GCI.7"
    #   # Make sure the Models hierarchy is even in the score string
    #       if jsonD['ExperimentalEvidence']['Models'].present? && jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism'].present?
    #     animalmode = (jsonD['summary']['FinalClassification'] == 'No Reported Evidence') \
    #       && jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Count'] > 0 \
    #       && jsonD['ValidContradictoryEvidence']['Value'] == 'NO'
    #   else
    #     return ''
    #   end
    #     elsif type == 'GCI.5'
		# # Make sure the Models hierarchy is even in the score string
    #     if jsonD['ExperimentalEvidence']['Models'].present? && jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism'].present?
		# 	animalmode = (jsonD['summary']['FinalClassification'] == 'No Reported Evidence') \
		# 		&& jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Count'] > 0 \
		# 		&& jsonD['ValidContradictoryEvidence']['Value'] == 'NO'
		# else
		# 	return ''
		# end
    #   elsif type == 'GCI.5'
		# # Make sure the Models hierarchy is even in the score string
		# if jsonD['ExperimentalEvidence']['Models'].present? && jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism'].present?
		# 	animalmode = (jsonD['summary']['FinalClassification'] == 'No Reported Evidence') \
		# 		&& jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		# 		&& jsonD['ValidContradictoryEvidence']['Value'] == 'NO'
		# else
		# 	return ''
		# end
    #   elsif type == 'SOP5'
		# animalmode = (jsonD['scoreJson']['summary']['CalculatedClassification'] == 'No Reported Evidence') \
		# 	&& jsonD['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		# 	&& jsonD['ValidContradictoryEvidence']['Value'] == 'NO'
	  # else
	  #   animalmode = (jsonD['data']['FinalClassification'] == 'No Reported Evidence') \
		# 	&& jsonD['data']['ExperimentalEvidence']['Models']['NonHumanModelOrganism']['Value'] > 0 \
		# 	&& jsonD['data']['ValidContradictoryEvidence']['Value'] == 'NO'
	  # end      
	       
    #   if animalmode 
		# return "Animal Mode Only"
	  # else
	  #   return ''
	  # end
    # else
    #   return ''
    # end 
  end


  def print_affilate(affilate)
    if(affilate.first.nil?)
      return "n/a"
    else
      return affilate.first[:label]
    end 
  end

  def gci_SOP(sop)
    if(sop == "GCI.5" )
      return "SOP5"
    elsif(sop == "GCI.6" )
      return "SOP6"
    elsif(sop == "GCI.7" )
      return "SOP7"
    else
      return "SOP4"
    end 
  end

  def gci_SOP_version(sop)
    if(sop == "GCI.5" )
      return "Version 5"
    elsif(sop == "GCI.6" )
      return "Version 6"
    elsif(sop == "GCI.7" )
      return "Version 7"
    else
      return "Version 4"
    end 
  end

  def print_moi_score_gci(score, render=null)
    ## Send phil curtion tion
    if(score.present?)
      jsonD = ActiveSupport::JSON.decode(score)
      moi =  jsonD['ModeOfInheritance']

      ## The partition is designed to remove the HP info
      
      data = moi.partition("(").last

      case data
      when "HP:0000006)"
        if(render == "text")
          text = 'Autosomal Dominant'
        else
        text = 'AD'
        end
      when "HP:0000007)"
        if(render == "text")
          text = 'Autosomal Recessive'
        else
          text = 'AR'
        end
      when "HP:0001417)"
        if(render == "text")
          text = 'X-Linked'
        else
          text = 'XL'
        end
      when "HP:0001427)"
        if(render == "text")
          text = 'Mitochondrial'
        else
          text = 'MT'
        end
      else
        text = "Other"
      end

      return text
    end 
  end

  def print_moi_score_sop5(score, render=null)
    if(score.present?)
      jsonD = ActiveSupport::JSON.decode(score)
      moi =  jsonD['scoreJson']['ModeOfInheritance']

      ## The partition is designed to remove the HP info
      data = moi.partition("(").last

      case data
      when "HP:0000006)"
        if(render == "text")
          text = 'Autosomal Dominant'
        else
        text = 'AD'
        end
      when "HP:0000007)"
        if(render == "text")
          text = 'Autosomal Recessive'
        else
          text = 'AR'
        end
      when "HP:0001417)"
        if(render == "text")
          text = 'X-Linked'
        else
          text = 'XL'
        end
      when "HP:0001427)"
        if(render == "text")
          text = 'Mitochondrial'
        else
          text = 'MT'
        end
      else
        text = "Other"
      end

      return text
    end 
  end

  def print_moi_score(score, render=null)
    if(score.present?)
      jsonD = ActiveSupport::JSON.decode(score)
      moi =  jsonD['data']['ModeOfInheritance']

      ## The partition is designed to remove the HP info
      data = moi.partition("(").last

      case data
      when "HP:0000006)"
        if(render == "text")
          text = 'Autosomal Dominant'
        else
        text = 'AD'
        end
      when "HP:0000007)"
        if(render == "text")
          text = 'Autosomal Recessive'
        else
          text = 'AR'
        end
      when "HP:0001417)"
        if(render == "text")
          text = 'X-Linked'
        else
          text = 'XL'
        end
      when "HP:0001427)"
        if(render == "text")
          text = 'Mitochondrial'
        else
          text = 'MT'
        end
      else
        text = "Other"
      end

      return text
    end 
  end

  # Return the key for the entity describing which assertions have been performed
  def entity_assertion_key(entity)
    types = [[ActionabilityAssertion, "clinicalActionability"],
             [GeneDiseaseAssertion, "clinicalValidity"],
             [GeneDosageAssertion, "dosageSensitivity"]]

    contents = types.reduce("") do |acc, t|
      acc + content_tag(:div, class: 'col-sm-3 padding-right-none') do 
        if entity.assertions.any? { |a| a.is_a?(t.first) }
          link_to(image_tag("#{t.second}-on.png", class: "img-responsive"),
                  entity, class: "menu_icon")
        else 
          link_to(image_tag("#{t.second}-off.png", class: "img-responsive"),
                  entity, class: "menu_icon")
        end
      end
    end

    # contents += content_tag(:div, class: 'col-sm-3 padding-right-none') do 
    #   link_to(image_tag("genomeResource-on.png", class: "img-responsive"),
    #           entity, class: "menu_icon")
    # end

    content_tag(:div, class: 'col-sm-2  hidden-xs') do
      raw(contents)
    end
  end

  # STRING.downcase.tr(' ', '+')

  def info_popover(type, item, message = '', option = '')

    if option == "strong"
      message = "<strong>" + message + "</strong> "
    end

    # Check which type and set the info
    if type == "gene-curation"
      text = "Can variation in this gene cause disease?"
      img = "clinicalValidity-off.png"
      img_color = "clinicalValidity-on.png"
      title = "Gene-Disease Validity"
      href = "https://www.clinicalgenome.org/curation-activities/gene-disease-validity/"
      href_score = "https://www.clinicalgenome.org/site/assets/files/5967/gene-validity_classification.pdf"
      text_score = "Gene-Disease Validity classification and scoring information"
    elsif type == "actionability"
      text = "How does this genetic diagnosis impact medical management?"
      img = "clinicalActionability-off.png"
      img_color = "clinicalActionability-on.png"
      title = "Clinical Actionability"
      href = "https://www.clinicalgenome.org/curation-activities/clinical-actionability/"
      href_score = "https://www.clinicalgenome.org/site/assets/files/6026/actionability_sq_metric.jpg"
      text_score = "Clinical Actionability scoring information"
    elsif type == "gene-dosage"
      text = "Is haploinsufficiency or triplosensitivity an established disease mechanism for this gene?"
      img = "dosageSensitivity-off.png"
      img_color = "dosageSensitivity-on.png"
      title = "Gene Dosage Sensitivity"
      href = "https://www.clinicalgenome.org/curation-activities/dosage-sensitivity/"
      href_score = "https://www.ncbi.nlm.nih.gov/projects/dbvar/clingen/help.shtml#review"
      text_score = "Gene Dosage Sensitivity rating system"
    end

    if option == "logo-inline"
      logo = image_tag(img_color, style: "width:20px")
    else
      logo = ""
    end

    # Check what is needed and build it
    if item == "heading"
      ("<a tabindex=\"0\" class=\"info-popover\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"top\" data-trigger=\"focus\" role=\"button\" data-title=\"Learn more\" data-href=\"" + href + "\" data-content=\"" + text + "\"> " + image_tag(img, style: "width:40px") + "<br /> " + title + " <i class=\"glyphicon glyphicon-question-sign text-muted\"></i></a>").html_safe

    elsif item == "help"
      ("<a tabindex=\"0\" class=\"info-popover\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"top\" data-trigger=\"focus\" role=\"button\" data-title=\"Learn more\" data-href=\"" + href + "\" data-content=\"" + text + "\"> " + logo + " " + title + " <i class=\"glyphicon glyphicon-question-sign text-muted\"></i></a>").html_safe
    
    elsif item == "score"
      ("<a tabindex=\"0\" class=\"info-popover\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"top\" data-trigger=\"focus\" role=\"button\" data-title=\"Learn more about classifications \" data-href=\"" + href_score + "\" data-content=\"" + text_score + "\">" + message + " <i class=\"glyphicon glyphicon-question-sign text-muted\"></i></a>").html_safe
    end

  end

  def gene_medgen_genetics_summary(item, var = '')

    var = var.parameterize('+')

    title = "MedGen: Genetics Summary"
    # MedGen - Genetics Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term="medgen+gtr+tests+clinical"[Filter]+BRCA2#Additional_description

    if item == "logo"
      "medgen.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a id=\"external_gene_medgen_genetics_summary\" class='externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen/?term=\"medgen+gtr+tests+clinical\"[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_medgen_genetics_summary\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen/?term=\"medgen+gtr+tests+clinical\"[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Organizes information related to human medical genetics, such as attributes of conditions with a genetic contribution."
    end
  end

  def gene_genetic_practice_guidelines(item, var = '')

    var = var.parameterize('+')

    title = "Genetic Practice Guidelines: Gene"
    # Genetic Practice Guidelines
    # https://www.ncbi.nlm.nih.gov/medgen?term=("has guideline"%5BProperties%5D) AND BRCA2#Professional_guidelines

    if item == "logo"
      "genetic_practice_guidelines.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a id=\"external_gene_genetic_practice_guidelines\" class='externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen?term=(\"has guideline\"%5BProperties%5D) AND " + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

     elsif item == "button"
      ("<a id=\"external_gene_genetic_practice_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen?term=(\"has guideline\"%5BProperties%5D) AND " + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "As guidelines are identified that relate to a disorder, gene, or variation, staff at NCBI connect them to the appropriate records. This page provides an alphabetical list of the professional practice guidelines, position statements, and recommendations that have been identified."
    end
  end

  def gene_dosage_sensitivity(item, var = '')

    var = var.parameterize('+')

    title = "ClinGen: Dosage Sensitivity"

    if item == "logo"
      "dosage_sensitivity.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_dosage_sensitivity\" href='https://www.ncbi.nlm.nih.gov/projects/dbvar/clingen/clingen_gene.cgi?sym=" + var + "&subject' target=\"_blank\">" + title + "</a>").html_safe
    
    elsif item == "button"
      ("<a id=\"external_gene_dosage_sensitivity\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/projects/dbvar/clingen/clingen_gene.cgi?sym=" + var + "&subject' target=\"_blank\">" + title + "</a>").html_safe
    
    elsif item == "url"
      ("https://www.ncbi.nlm.nih.gov/projects/dbvar/clingen/clingen_gene.cgi?sym=" + var + "&subject").html_safe

    elsif item == "text"
      "The Clinical Genome Resource (ClinGen) consortium is curating genes and regions of the genome to assess whether there is evidence to support that these genes/regions are dosage sensitive and should be targeted on a cytogenomic array."
    end
  end

  def gene_gtr_gene_tests(item, var = '')

    var = var.parameterize('+')

    title = "GTR: Gene Tests"
    # GTR - Gene Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=BRCA2&test_type=Clinical&certificate=CLIA Certified

    if item == "logo"
      "gtr.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_gtr_gene_tests\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_gtr_gene_tests\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "A voluntary registry of genetic tests and laboratories, with detailed information about the tests such as what is measured and analytic and clinical validity.  GTR also is a nexus for information about genetic conditions and provides context-specific links to a variety of resources, including practice guidelines, published literature, and genetic data/information. The scope of GTR includes single gene tests for Mendelian disorders, somatic/cancer tests and pharmacogenetic tests including complex arrays, panels."
    end
  end

  def gene_pharmgkb_gene(item, var = '')

    var = var.parameterize('+')

    title = "PharmGKB: Gene"
    # PharmGKB
    # https://www.pharmgkb.org/search/search.action?typeFilter=Gene&exactMatch=false&query=BRCA2

    if item == "logo"
      "pharmgkb.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_pharmgkb_gene\" href='https://www.pharmgkb.org/hgnc/" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_pharmgkb_gene\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.pharmgkb.org/hgnc/" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "PharmGKB is a comprehensive resource that curates knowledge about the impact of genetic variation on drug response for clinicians and researchers."
    end
  end

  def gene_omim(item, var = '')

    var = var.parameterize('+')

    title = "OMIM: Gene"
    # OMIM
    # http://omim.org/search?index=entry&start=1&limit=10&search=approved_gene_symbol%3ABRCA2+AND+gene_id_exists&sort=score+desc%2C+prefix_sort+desc

    if item == "logo"
      "omim.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_omim\" href='http://omim.org/search?index=entry&start=1&limit=10&search=approved_gene_symbol%3A" + var + "+AND+gene_id_exists&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_omim\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://omim.org/search?index=entry&start=1&limit=10&search=approved_gene_symbol%3A" + var + "+AND+gene_id_exists&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An Online Catalog of Human Genes and Genetic Disorders."
    end
  end

  def gene_genetics_home_reference(item, var = '')

    var = var.parameterize('+')

    title = "Genetics Home Reference"
    # Genetics Home Reference
    # https://ghr.nlm.nih.gov/search?query=BRCA2

    if item == "logo"
      "genetics_home_reference.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_genetics_home_reference\" href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_genetics_home_reference\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Genetics Home Reference provides consumer-friendly information about the effects of genetic variation on human health."
    end
  end

  def gene_gene_reviews(item, var = '')

    var = var.parameterize('+')

    title = "Gene Reviews"
    # Gene Reviews
    # https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=BRCA2%5BGeneSymbol%5D

    if item == "logo"
      "gene_reviews.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_gene_reviews\" href='https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=" + var + "%5BGeneSymbol%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_gene_reviews\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=" + var + "%5BGeneSymbol%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "url"
      ("https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=" + var + "%5BGeneSymbol%5D").html_safe

    elsif item == "text"
      "An international point-of-care resource for busy clinicians, provides clinically relevant and medically actionable information for inherited conditions in a standardized journal-style format, covering diagnosis, management, and genetic counseling for patients and their families. "
    end
  end

  def gene_clinvar(item, var = '')

    var = var.parameterize('+')

    title = "ClinVar - Gene"
    # ClinVar - Gene
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22BRCA2%22

    if item == "logo"
      "clinvar.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_clinvar\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_clinvar\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "ClinGen and ClinVar are close partners and have established a collaborative working relationship. ClinVar is a critical resource for ClinGen. ClinVar aggregates information about genomic variation and its relationship to human health."
    end
  end

  def gene_clinvar_acmg_variants(item, var = '')

    var = var.parameterize('+')

    title = "ClinVar - ACMG Incidental variants"
    # ClinVar - ACMG Incidental variants
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22gene+acmg+incidental+2013%22%5BProperties%5D+%22BRCA2%22

    if item == "logo"
      "clinvar.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_clinvar_acmg_variants\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22gene+acmg+incidental+2013%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_clinvar_acmg_variants\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22gene+acmg+incidental+2013%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "ClinGen and ClinVar are close partners and have established a collaborative working relationship. ClinVar is a critical resource for ClinGen. ClinVar aggregates information about genomic variation and its relationship to human health."
    end
  end

  def gene_1000_genomes(item, var = '')

    var = var.parameterize('+')

    title = "1000 Genomes"
    # 1000 Genomes
    # http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22BRCA2%22

    if item == "logo"
      "1000_genomes.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_1000_genomes\" href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_1000_genomes\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An interactive graphical viewer that allows users to explore variant calls, genotype calls and supporting evidence (such as aligned sequence reads) that have been produced by the 1000 Genomes Project.
 View Information"
    end
  end

  def gene_ncbi_browser(item, var = '')

    var = var.parameterize('+')

    title = "NCBI Browser"
    # https://www.ncbi.nlm.nih.gov/variation/tools/1000genomes/?q=BRCA2%5bgene%5d

    if item == "logo"
      "ncbi.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_ncbi_browser\" href='https://www.ncbi.nlm.nih.gov/variation/tools/1000genomes/?q=" + var + "%5bgene%5d' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_ncbi_browser\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/variation/tools/1000genomes/?q=" + var + "%5bgene%5d' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "The 1000 Genomes Browser allows users to explore variant calls, genotype calls and supporting sequence read alignments that have been produced by the 1000 Genomes project."
    end
  end

  def condition_gtr_disease_tests(item, var = '')

    var = var.parameterize('+')

    title = "GTR - Disease Tests"
    # GTR - Disease Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=BREAST+CANCER[DISNAME]%20AND%20(testtype_clinical[PROP])

    if item == "logo"
      "gtr.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_gtr_disease_tests\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "[DISNAME]%20AND%20(testtype_clinical[PROP])' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_gtr_disease_tests\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "[DISNAME]%20AND%20(testtype_clinical[PROP])' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "The Genetic Testing Registry (GTR®) provides a central location for voluntary submission of genetic test information by providers. "
    end
  end

  def condition_genetic_practice_guidelines(item, var = '')

    var = var.gsub '_', ':'
    var = var.parameterize('+')


    title = "Genetic Practice Guidelines - Genetic Disease Summary"
    # Genetic Practice Guidelines 0 Genetic Disease Summary
    # https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20114480%5BMIM%20ID%5D#Professional_guidelines
    
    if item == "logo"
      "genetic_practice_guidelines.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_genetic_practice_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

     elsif item == "button"
      ("<a id=\"external_condition_genetic_practice_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "As guidelines are identified that relate to a disorder, gene, or variation, staff at NCBI connect them to the appropriate records. This page provides an alphabetical list of the professional practice guidelines, position statements, and recommendations that have been identified."
    end
  end  

  def condition_omim(item, var = '')

    var = var.parameterize('+')

    title = "OMIM: Genetic Disease Summary"
    # OMIM
    # http://www.omim.org/entry/114480

    if item == "logo"
      "omim.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_omim\" href='https://www.omim.org/search/?index=entry&search=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_omim\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.omim.org/search/?index=entry&search=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An Online Catalog of Human Genes and Genetic Disorders."
    end
  end

  def condition_pharmgkb(item, var = '')

    var = var.parameterize('+')

    title = "PharmGKB - Disease"
    # PharmGKB - Disease
    # https://www.pharmgkb.org/search/search.action?typeFilter=Disease&exactMatch=false&query=BREAST+CANCER

    if item == "logo"
      "pharmgkb.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_pharmgkb\" href='https://www.pharmgkb.org/search/search.action?typeFilter=Disease&exactMatch=false&query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_pharmgkb\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.pharmgkb.org/search/search.action?typeFilter=Disease&exactMatch=false&query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "PharmGKB is a comprehensive resource that curates knowledge about the impact of genetic variation on drug response for clinicians and researchers."
    end
  end

  def condition_medgen_genetic_summary(item, var = '')

    var = var.parameterize('+')

    title = "MedGen - Genetics Summary"
    # MedGen - Genetics Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+BREAST+CANCER#Additional_description

    if item == "logo"
      "medgen.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_medgen_genetic_summary\" href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_medgen_genetic_summary\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Organizes information related to human medical genetics, such as attributes of conditions with a genetic contribution."
    end
  end

  def condition_genetics_home_reference(item, var = '')

    var = var.parameterize('+')

    title = "Genetics Home Reference - Genetic conditions"
    # Genetics Home Reference - Genetic conditions
    # https://ghr.nlm.nih.gov/search?query=BREAST+CANCER

    if item == "logo"
      "genetics_home_reference.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_genetics_home_reference\" href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_genetics_home_reference\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Genetics Home Reference provides consumer-friendly information about the effects of genetic variations on human health."
    end
  end

  def condition_clinvar_variants_related_to_genetic_disease(item, var = '')

    var = var.parameterize('+')

    title = "ClinVar - Variants related to Genetic Disease"
    # ClinVar - Variants related to Genetic Disease
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22BREAST+CANCER%22%5BDisease/Phenotype%5D

    if item == "logo"
      "clinvar.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_clinvar_variants_related_to_genetic_disease\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22%5BDisease/Phenotype%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_clinvar_variants_related_to_genetic_disease\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22%5BDisease/Phenotype%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "ClinVar aggregates information about genomic variation and its relationship to human health."
    end
  end

  def condition_1000_genomes(item, var = '')

    var = var.parameterize('+')

    title = "1000 Genomes - General Disease"
    # 1000 Genomes - General Disease
    # https://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22BREAST+CANCER%22

    if item == "logo"
      "1000_genomes.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_condition_1000_genomes\" href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_condition_1000_genomes\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An interactive graphical viewer that allows users to explore variant calls, genotype calls and supporting evidence (such as aligned sequence reads) that have been produced by the 1000 Genomes Project.
 View Information"
    end
  end

  def drug_pharmgkb_dosing_guidelines(item, var = '')

    var = var.parameterize('+')

    title = "PharmGKB - PGx knowledge"
    # PharmGKB - Dosing guidelines
    # https://www.pharmgkb.org/search/search.action?exactMatch=false&annoFilter=DOSING_GUIDELINES&query=Bayer+Aspirin

    if item == "logo"
      "pharmgkb.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_pharmgkb_dosing_guidelines\" href='https://www.pharmgkb.org/rxnorm/" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_pharmgkb_dosing_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.pharmgkb.org/rxnorm/" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "PharmGKB is a comprehensive resource that curates knowledge about the impact of genetic variation on drug response for clinicians and researchers."
    end
  end

  def drug_gtr_clia(item, var = '')

    var = var.parameterize('+')

    title = "GTR - CLIA certified Genetic Tests"
    # GTR - CLIA certified Genetic Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=Bayer+Aspirin&test_type=Clinical&certificate=CLIA%20Certified

    if item == "logo"
      "gtr.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_gtr_clia\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA%20Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_gtr_clia\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA%20Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "The Genetic Testing Registry (GTR®) provides a central location for voluntary submission of genetic test information by providers. "
    end
  end  

  def gene_cpic_pharmacogenomics_guidelines(item, var = '')

    var = var.partition(" ").first
    var = var.parameterize('+')

    title = "CPIC Pharmacogenomics Prescribing Guidelines"
    # CPIC Pharmacogenomics Guidelines - Guidelines from NCBI
    # https://www.ncbi.nlm.nih.gov/medgen/docs/guideline/#CPIC

    if item == "logo"
      "cpic.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_gene_cpic_pharmacogenomics_guidelines\" href='https://cpicpgx.org/?s=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_gene_cpic_pharmacogenomics_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://cpicpgx.org/?s=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "The Clinical Pharmacogenetics Implementation Consortium (CPIC) was formed as a shared project between PharmGKB and the Pharmacogenomics Research Network (PGRN)."
    end
  end

  def drug_cpic_pharmacogenomics_guidelines(item, var = '')

    var = var.partition(" ").first
    var = var.parameterize('+')

    title = "CPIC Pharmacogenomics Prescribing Guidelines"
    # CPIC Pharmacogenomics Guidelines - Guidelines from NCBI
    # https://www.ncbi.nlm.nih.gov/medgen/docs/guideline/#CPIC

    if item == "logo"
      "cpic.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_cpic_pharmacogenomics_guidelines\" href='https://cpicpgx.org/?s=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_cpic_pharmacogenomics_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://cpicpgx.org/?s=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "The Clinical Pharmacogenetics Implementation Consortium (CPIC) was formed as a shared project between PharmGKB and the Pharmacogenomics Research Network (PGRN)."
    end
  end

  def drug_medgen_drug_gene_summary(item, var = '')

    var = var.parameterize('+')

    title = "MedGen - Drug/Gene Summary"
    # MedGen - Drug/Gene Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+Bayer+Aspirin#Additional_description

    if item == "logo"
      "medgen.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_medgen_drug_gene_summary\" href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_medgen_drug_gene_summary\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Organizes information related to human medical genetics, such as attributes of conditions with a genetic contribution."
    end
  end

  def drug_genetic_practice_guidelines(item, var = '')

    var = var.parameterize('+')

    title = "Genetic Practice Guidelines - Drug/Gene Summary"
    # Genetic Practice Guidelines - Drug/Gene Summary
    # https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20Bayer+Aspirin#Professional_guidelines

    if item == "logo"
      "genetic_practice_guidelines.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_genetic_practice_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_genetic_practice_guidelines\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "As guidelines are identified that relate to a disorder, gene, or variation, staff at NCBI connect them to the appropriate records. This page provides an alphabetical list of the professional practice guidelines, position statements, and recommendations that have been identified."
    end
  end

  def drug_omim(item, var = '')

    var = var.parameterize('+')

    title = "OMIM - Drug/Gene Summary"
    # OMIM - Drug/Gene Summary
    # http://omim.org/search?index=entry&start=1&limit=10&search=Bayer+Aspirin&sort=score+desc%2C+prefix_sort+desc

    if item == "logo"
      "omim.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_omim\" href='http://omim.org/search?index=entry&start=1&limit=10&search=" + var + "&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_omim\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://omim.org/search?index=entry&start=1&limit=10&search=" + var + "&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An Online Catalog of Human Genes and Genetic Disorders."
    end
  end

  def drug_clinvar_variants_with_drug_response(item, var = '')

    var = var.parameterize('+')

    title = "ClinVar - Variants annotated with Drug Response"
    # ClinVar - Variants annotated with Drug Response
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22Bayer+Aspirin%22

    if item == "logo"
      "clinvar.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_clinvar_variants_with_drug_response\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_clinvar_variants_with_drug_response\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "ClinGen and ClinVar are close partners and have established a collaborative working relationship. ClinVar is a critical resource for ClinGen. ClinVar aggregates information about genomic variation and its relationship to human health."
    end
  end

  def drug_clinvar_medication_ingredient(item, var = '')

    var = var.parameterize('+')

    title = "ClinVar - Medication main ingredient Search"
    # ClinVar - Medication main ingredient Search
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22Bayer+Aspirin%22

    if item == "logo"
      "clinvar.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_clinvar_medication_ingredient\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_clinvar_medication_ingredient\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "ClinGen and ClinVar are close partners and have established a collaborative working relationship. ClinVar is a critical resource for ClinGen. ClinVar aggregates information about genomic variation and its relationship to human health."
    end
  end

  def drug_1000_genomes_general_medication(item, var = '')

    var = var.parameterize('+')

    title = "1000 Genomes - General Medication"
    # 1000 Genomes - General Medication
    # http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22Bayer+Aspirin%22

    if item == "logo"
      "1000_genomes.png"

    elsif item == "title"
      title

    elsif item == "link"
      ("<a class='externalresource' title='" + title + "' id=\"external_drug_1000_genomes_general_medication\" href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "button"
      ("<a id=\"external_drug_1000_genomes_general_medication\" class='btn btn-default btn-xs externalresource' title='" + title + "' href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "An interactive graphical viewer that allows users to explore variant calls, genotype calls and supporting evidence (such as aligned sequence reads) that have been produced by the 1000 Genomes Project.
 View Information"
    end
  end

end
