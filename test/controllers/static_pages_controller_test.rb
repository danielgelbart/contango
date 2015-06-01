require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get limit_access" do
    get :limit_access
    assert_response :success
  end

end
