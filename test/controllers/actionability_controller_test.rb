require 'test_helper'

class ActionabilityControllerTest < ActionDispatch::IntegrationTest

  test "should get actionability index" do
    get '/actionability/'
    assert_response :success
    assert_equal 'text/html', @response.content_type
    assert_select "title", "Clinical Actionability Curations - ClinGen Knowledge Base | Clinical Genome Resource"
  end

end
