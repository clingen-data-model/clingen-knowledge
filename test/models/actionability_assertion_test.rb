require 'test_helper'

class GeneTest < ActiveSupport::TestCase
  include ActionabilityHelper

  test "should get assertions list" do
    assertions = index_list(1)
    assert_not_empty assertions
    assertion = assertions.first
    assert_not assertion.blank?
    assert_not_empty assertion[:genes]
    assert_not assertion[:genes].first[:symbol].blank?
    assert_not assertion[:genes].first[:hgnc_id].blank?
    assert_not_empty assertion[:conditions]
    assert_not assertion[:conditions].first[:label].blank?
    assert_not assertion[:conditions].first[:curie].blank?
    assert_not_empty assertion[:interventions]
    assert_not assertion[:interventions].first[:label].blank?
    assert_not assertion[:interventions].first[:scores].blank?
    assert_not assertion[:file].blank?
    assert_not assertion[:date].blank?
  end

end
