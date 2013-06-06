require 'test_helper'

class JoinStreamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get counter" do
    get :counter
    assert_response :success
  end

end
