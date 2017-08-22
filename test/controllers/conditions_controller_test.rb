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

  # test "required conditions fields have values" do
  #   condition = Condition.page(@page).per(1).first
  #   assert_not_nil condition.curie, 'Condition curie is nil.'
  #   assert_not_nil condition.label, 'Condition label is nil.'
  # end
  #
  # test "required condition fields have values" do
  #   condition = Condition.find_by(curie: 'Orphanet_199354')
  #   # term_label = truncate(condition.label, :length => 50, :omission => '...')
  #   puts condition
  #   assert_not_nil condition.curie, 'Condition curie is nil.'
  #   assert_not_nil condition.label, 'Condition label is nil.'
  #   # assert_not_nil term_label
  # end

end
