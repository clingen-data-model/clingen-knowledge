require 'test_helper'

class GeneDosageControllerTest < ActionDispatch::IntegrationTest

  test "should get gene dosage assertions index" do
    get '/gene-dosage/'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Gene Dosage Curations - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
