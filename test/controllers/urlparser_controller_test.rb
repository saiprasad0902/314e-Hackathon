require 'test_helper'

class UrlparserControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get urlparser_index_url
    assert_response :success
  end

  test "should get show" do
    get urlparser_show_url
    assert_response :success
  end

  test "should alert when URL is empty" do
    get urlparser_index_url, params: { url: "" }
    assert_equal "URL cant be empty", flash[:alert]
  end

  test "should alert when URL is bad" do
    get urlparser_index_url, params: { url: "abc" }
    assert_equal "URL invalid", flash[:alert]
  end

  test "should get data when URL is valid" do
    get urlparser_index_url, params: { url: "https://www.314e.com/", parent: 1 }
    assert_response :success
  end

end
