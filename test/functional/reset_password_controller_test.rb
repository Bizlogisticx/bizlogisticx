require 'test_helper'

class ResetPasswordControllerTest < ActionController::TestCase
  test "should get password" do
    get :password
    assert_response :success
  end

  test "should get password_create" do
    get :password_create
    assert_response :success
  end

end
