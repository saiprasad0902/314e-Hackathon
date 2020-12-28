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

end
