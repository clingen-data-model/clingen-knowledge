require 'test_helper'

class GenesControllerTest < ActionDispatch::IntegrationTest

  test "should get genes index" do
    get genes_path
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Genes - ClinGen Knowledge Base | Clinical Genome Resource"
    assert_select "h2", "Genes"
  end

  test "should get gene page" do
    get gene_path(id: 'HGNC:24086')
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "A1CF - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
