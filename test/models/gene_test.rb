require 'test_helper'

class GeneTest < ActiveSupport::TestCase

  test "should find by term" do
    genes = Gene.find_by_term("SMAD3")
    assert_not_empty genes
  end

  test "should generate complete list for curation summary page" do 
    summary = Gene.genes_summary
    assert_not_empty summary
    # TODO rest of test
  end

end
