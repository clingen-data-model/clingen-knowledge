require 'test_helper'

class GenesControllerTest < ActionDispatch::IntegrationTest

  test "should get genes index" do
    get genes_path
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Genes - ClinGen Knowledge Base | Clinical Genome Resource"
  end

  test "should get gene page" do
    get gene_path(id: 'HGNC:24086')
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "A1CF - ClinGen Knowledge Base | Clinical Genome Resource"
  end

  # test "correct gene data returned for index" do
  #   gene = Gene.all.with_associations(:assertions).page(@page).per(1).first
  #   assert_not_nil gene.symbol, 'Gene symbol is nil'
  #   assert_not_nil gene.hgnc_id, 'Gene hgnc_id is nil'
  #   assert_not_nil gene.name, 'Gene name is nil'
  # end
  #
  # test "correct gene data returned for show" do
  #   gene = Gene.find_by(hgnc_id: "HGNC:165")
  #   assert_not_nil gene.symbol, 'Gene symbol is nil'
  #   assert_not_nil gene.hgnc_id, 'Gene hgnc_id is nil'
  #   assert_not_nil gene.location, 'Gene location is nil'
  # end

end
