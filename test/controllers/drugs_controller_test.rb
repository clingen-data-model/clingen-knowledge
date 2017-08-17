require 'test_helper'

class DrugsControllerTest < ActionDispatch::IntegrationTest

  test "should get drugs index" do
    get drugs_path
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Drugs - ClinGen Knowledge Base | Clinical Genome Resource"
  end

  test "should get gene page" do
    get drugs_path + '/RxCUI_562251/external_resources_drugs'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Amoxicillin 250 MG / Clavul... - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
