require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "shuld redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "shuld direct edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "shuld direct update when not logged in" do
    patch user_path(@user),params: { user: { name: @user.name,
                                            email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "shuld not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                  user:   { password:              @other_user.password,
                                            password_confirmation: @other_user.password_confirmation,
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "shuld redirect edit when logged in wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "shuld redirect update when logged in wrong user" do
    log_in_as(@other_user)
    patch user_path(@user),params: { user: { name: @user.name,
                                            email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destory when logged in a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
end
