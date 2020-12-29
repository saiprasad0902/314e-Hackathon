require 'test_helper'

class UrlparserHelperTest < ActionDispatch::IntegrationTest
  def setup
    @host = "https://www.314e.com/"
    @parser = UrlparserHelper::Parser.new
    @valid_tags = Array["meta", "title", "link", "script", "style", "noscript",
                        "head", "div", "img", "a", "i", "span", "sup", "li", "ul",
                        "nav", "header", "p", "rs-layer", "br", "h2", "rs-slide",
                        "h1", "rs-slides", "rs-static-layers", "rs-module", "rs-module-wrap",
                        "section", "h4", "time", "article", "main", "strong", "h6", "footer",
                        "body", "html"]
    @parser.fetch_all(@host)
  end

  def teardown
    @parser = nil
    @host = nil
    @valid_tags = nil
  end

  test "fetch_all_test" do
      assert_not_nil( @parser.instance_variable_get(:@frequent_words))
      assert_not_nil( @parser.instance_variable_get(:@frequent_word_pairs))
      assert_not_nil( @parser.instance_variable_get(:@hrefs))
  end

  test "fetch_tags_test" do
    @parser.fetch_tags
    assert(@valid_tags.to_s == @parser.instance_variable_get(:@tags).keys.to_a.to_s)
  end

  test "get_all_hrefs_text" do
    @parser.get_all_hrefs
    assert_not_nil(@parser.instance_variable_get(:@hrefs))
  end

  test "get_frequent_words_test" do
    @parser.get_frequent_words
    assert_not_nil(@parser.instance_variable_get(:@frequent_words))
  end

  test "get_frequent_pair_words_test" do
    @parser.get_frequent_pair_words
    assert_not_nil(@parser.instance_variable_get(:@frequent_word_pairs))
  end
end