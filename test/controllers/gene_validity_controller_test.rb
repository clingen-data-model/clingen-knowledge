require 'test_helper'

class GeneValidityControllerTest < ActionDispatch::IntegrationTest

  test "should get gene disease assertions index" do
    get '/gene-validity/'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Gene Validity Curations - ClinGen Knowledge Base | Clinical Genome Resource"
  end

  test "should get validity page" do
    get '/gene-validity/8249'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Gene Validity Curation - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
