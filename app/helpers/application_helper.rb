module ApplicationHelper

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

    contents += content_tag(:div, class: 'col-sm-3 padding-right-none') do 
      link_to(image_tag("genomeResource-on.png", class: "img-responsive"),
              entity, class: "menu_icon")
    end

    content_tag(:div, class: 'col-sm-2') do
      raw(contents)
    end
  end

  # STRING.downcase.tr(' ', '+')

  def gene_medgen_genetics_summary(item, var)

    title = "MedGen: Genetics Summary"
    # MedGen - Genetics Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term="medgen+gtr+tests+clinical"[Filter]+BRCA2#Additional_description

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_medgen_genetics_summary\" href=\"https://www.ncbi.nlm.nih.gov/medgen/?term='medgen+gtr+tests+clinical'[Filter]+" + var + "#Additional_description\" target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_genetic_practice_guidelines(item, var)

    title = "Genetic Practice Guidelines: Gene"
    # Genetic Practice Guidelines
    # https://www.ncbi.nlm.nih.gov/medgen?term=("has guideline"%5BProperties%5D) AND BRCA2#Professional_guidelines

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_genetic_practice_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen?term=(\"has guideline\"%5BProperties%5D) AND " + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_gtr_gene_tests(item, var)

    title = "GTR: Gene Tests"
    # GTR - Gene Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=BRCA2&test_type=Clinical&certificate=CLIA Certified

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_gtr_gene_tests\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_pharmgkb_gene(item, var)

    title = "PharmGKB: Gene"
    # PharmGKB
    # https://www.pharmgkb.org/search/search.action?typeFilter=Gene&exactMatch=false&query=BRCA2

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_pharmgkb_gene\" href='https://www.pharmgkb.org/search/search.action?typeFilter=Gene&exactMatch=false&query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_omim(item, var)

    title = "OMIM: Gene"
    # OMIM
    # http://omim.org/search?index=entry&start=1&limit=10&search=approved_gene_symbol%3ABRCA2+AND+gene_id_exists&sort=score+desc%2C+prefix_sort+desc

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_omim\" href='http://omim.org/search?index=entry&start=1&limit=10&search=approved_gene_symbol%3A" + var + "+AND+gene_id_exists&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_genetics_home_reference(item, var)

    title = "Genetics Home Reference"
    # Genetics Home Reference
    # https://ghr.nlm.nih.gov/search?query=BRCA2

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_genetics_home_reference\" href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_gene_reviews(item, var)

    title = "Gene Reviews"
    # Gene Reviews
    # https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=BRCA2%5BGeneSymbol%5D

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_gene_reviews\" href='https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=" + var + "%5BGeneSymbol%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_clinvar(item, var)

    title = "ClinVar - Gene"
    # ClinVar - Gene
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22BRCA2%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_clinvar\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_clinvar_acmg_variants(item, var)

    title = "ClinVar - ACMG Incidental variants"
    # ClinVar - ACMG Incidental variants
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22gene+acmg+incidental+2013%22%5BProperties%5D+%22BRCA2%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_clinvar_acmg_variants\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22gene+acmg+incidental+2013%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_1000_enomes(item, var)

    title = "1000 Genomes"
    # 1000 Genomes
    # http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22BRCA2%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_1000_enomes\" href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def gene_ncbi_browser(item, var)

    title = "NCBI Browser"
    # 1000 Genomes
    # https://www.ncbi.nlm.nih.gov/variation/tools/1000genomes/?q=BRCA2%5bgene%5d

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_gene_ncbi_browser\" href='https://www.ncbi.nlm.nih.gov/variation/tools/1000genomes/?q=" + var + "%5bgene%5d' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_gtr_disease_tests(item, var)

    title = "GTR - Disease Tests"
    # GTR - Disease Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=BREAST+CANCER[DISNAME]%20AND%20(testtype_clinical[PROP])

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_gtr_disease_tests\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "[DISNAME]%20AND%20(testtype_clinical[PROP])' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_genetic_practice_guidelines(item, var)

    title = "Genetic Practice Guidelines - Genetic Disease Summary"
    # Genetic Practice Guidelines 0 Genetic Disease Summary
    # https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20114480%5BMIM%20ID%5D#Professional_guidelines
    
    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_genetic_practice_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "%5BMIM%20ID%5D#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end  

  def condition_omim(item, var)

    title = "OMIM: Genetic Disease Summary"
    # OMIM
    # http://www.omim.org/entry/114480

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_omim\" href='http://www.omim.org/entry/" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_pharmgkb(item, var)

    title = "PharmGKB - Disease"
    # PharmGKB - Disease
    # https://www.pharmgkb.org/search/search.action?typeFilter=Disease&exactMatch=false&query=BREAST+CANCER

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_pharmgkb\" href='https://www.pharmgkb.org/search/search.action?typeFilter=Disease&exactMatch=false&query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_medgen_genetic_summary(item, var)

    title = "MedGen - Genetics Summary"
    # MedGen - Genetics Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+BREAST+CANCER#Additional_description

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_medgen_genetic_summary\" href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_genetics_home_reference(item, var)

    title = "Genetics Home Reference - Genetic conditions"
    # Genetics Home Reference - Genetic conditions
    # https://ghr.nlm.nih.gov/search?query=BREAST+CANCER

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_genetics_home_reference\" href='https://ghr.nlm.nih.gov/search?query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_clinvar_variants_related_to_genetic_disease(item, var)

    title = "ClinVar - Variants related to Genetic Disease"
    # ClinVar - Variants related to Genetic Disease
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22BREAST+CANCER%22%5BDisease/Phenotype%5D

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_clinvar_variants_related_to_genetic_disease\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22%5BDisease/Phenotype%5D' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def condition_1000_genomes(item, var)

    title = "1000 Genomes - General Disease"
    # 1000 Genomes - General Disease
    # https://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22BREAST+CANCER%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_condition_1000_genomes\" href='https://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_pharmgkb_dosing_guidelines(item, var)

    title = "PharmGKB - Dosing guidelines"
    # PharmGKB - Dosing guidelines
    # https://www.pharmgkb.org/search/search.action?exactMatch=false&annoFilter=DOSING_GUIDELINES&query=Bayer+Aspirin

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_pharmgkb_dosing_guidelines\" href='https://www.pharmgkb.org/search/search.action?exactMatch=false&annoFilter=DOSING_GUIDELINES&query=" + var + "' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_gtr_clia(item, var)

    title = "GTR - CLIA certified Genetic Tests"
    # GTR - CLIA certified Genetic Tests
    # https://www.ncbi.nlm.nih.gov/gtr/tests/?term=Bayer+Aspirin&test_type=Clinical&certificate=CLIA%20Certified

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_gtr_clia\" href='https://www.ncbi.nlm.nih.gov/gtr/tests/?term=" + var + "&test_type=Clinical&certificate=CLIA%20Certified' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end  

  def drug_cpic_pharmacogenomics_guidelines(item, var)

    title = "CPIC Pharmacogenomics Guidelines - Guidelines from NCBI"
    # CPIC Pharmacogenomics Guidelines - Guidelines from NCBI
    # https://www.ncbi.nlm.nih.gov/medgen/docs/guideline/#CPIC

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_cpic_pharmacogenomics_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen/docs/guideline/#CPIC' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_medgen_drug_gene_summary(item, var)

    title = "MedGen - Drug/Gene Summary"
    # MedGen - Drug/Gene Summary
    # https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+Bayer+Aspirin#Additional_description

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_medgen_drug_gene_summary\" href='https://www.ncbi.nlm.nih.gov/medgen/?term=%22medgen+gtr+tests+clinical%22[Filter]+" + var + "#Additional_description' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_genetic_practice_guidelines(item, var)

    title = "Genetic Practice Guidelines - Drug/Gene Summary"
    # Genetic Practice Guidelines - Drug/Gene Summary
    # https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20Bayer+Aspirin#Professional_guidelines

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_genetic_practice_guidelines\" href='https://www.ncbi.nlm.nih.gov/medgen?term=(%22has%20guideline%22%5BProperties%5D)%20AND%20" + var + "#Professional_guidelines' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_omim(item, var)

    title = "OMIM - Drug/Gene Summary"
    # OMIM - Drug/Gene Summary
    # http://omim.org/search?index=entry&start=1&limit=10&search=Bayer+Aspirin&sort=score+desc%2C+prefix_sort+desc

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_omim\" href='http://omim.org/search?index=entry&start=1&limit=10&search=" + var + "&sort=score+desc%2C+prefix_sort+desc' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_clinvar_variants_with_drug_response(item, var)

    title = "ClinVar - Variants annotated with Drug Response"
    # ClinVar - Variants annotated with Drug Response
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22Bayer+Aspirin%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_clinvar_variants_with_drug_response\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_clinvar_medication_ingredient(item, var)

    title = "ClinVar - Medication main ingredient Search"
    # ClinVar - Medication main ingredient Search
    # http://www.ncbi.nlm.nih.gov/clinvar/?term=%22clinsig+drug+response%22%5BProperties%5D+%22Bayer+Aspirin%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_clinvar_medication_ingredient\" href='http://www.ncbi.nlm.nih.gov/clinvar/?term=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end

  end

  def drug_1000_genomes_general_medication(item, var)

    title = "1000 Genomes - General Medication"
    # 1000 Genomes - General Medication
    # http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22Bayer+Aspirin%22

    if item == "logo"
      "hello world logo" + var

    elsif item == "link"
      ("<a id=\"external_drug_1000_genomes_general_medication\" href='http://browser.1000genomes.org/Homo_sapiens/Search/Results?site=ensembl&q=%22" + var + "%22' target=\"_blank\">" + title + "</a>").html_safe

    elsif item == "text"
      "Summary text here"
    end
  end

end
