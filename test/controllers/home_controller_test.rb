require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  
  test "should get index" do
    get '/'
    assert_response :success
  end

  test "should perform search for gene" do 
    get '/', params: {term: "CNTNAP"}
    assert_response :success
  end

  test "should perform search for gene and redirect" do
    get '/', params: {term: "SMAD3"}
    assert_redirected_to gene_path(id: 'HGNC:6769')
  end

  test "should perform search for condition" do 
    get '/', params: {term: "breast cancer"}
    assert_response :success
  end

  test "should perform search for drug" do
    get '/', params: {term: "Asprin"}
    assert_response :success
  end

  test "should get json for typeahead" do
    get home_index_url(format: :json), params: {term: "SMAD"}, xhr: true
    assert_response :success
    assert_equal "application/json", @response.content_type
  end

end
