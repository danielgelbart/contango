require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  test "should get get_filing" do
    get :get_filing
    assert_response :success
  end

end
