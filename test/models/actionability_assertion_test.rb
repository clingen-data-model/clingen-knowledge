require 'test_helper'

class ActionabilityAssertionTest < ActiveSupport::TestCase
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

  test "should get actionability scores hash" do
    act_assert_keys = [:efficacy, :evidence, :likelihood, :safety, :severity]
    act_assert = ActionabilityAssertion.act_scores
    assert_equal act_assert.keys.sort, act_assert_keys
    act_assert_keys.each { |k| assert_not act_assert[k].blank? }
    assert_not ActionabilityAssertion.act_cat_map(:severity).blank?
    assert_not ActionabilityAssertion.act_cat_map(:likelihood).blank?
    assert_not ActionabilityAssertion.act_cat_map(:effectiveness).blank?
    assert_not ActionabilityAssertion.act_cat_map(:intervention).blank?
    assert_not ActionabilityAssertion.act_cat_map(:evidence).blank?
  end

end
