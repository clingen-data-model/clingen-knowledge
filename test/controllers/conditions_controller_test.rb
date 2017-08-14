require 'test_helper'

class ConditionsControllerTest < ActionDispatch::IntegrationTest

  test "should get conditions index" do
    get conditions_path
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Conditions - ClinGen Knowledge Base | Clinical Genome Resource"
  end

  test "should get condition page" do
    get conditions_path + '/OMIM_207800'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "hyperargininemia - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
