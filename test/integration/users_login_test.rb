require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:nicholas)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {name: "WilliamKitty", email: "w.kitty@invalid.com" }}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "valid login grants permission for additional links" do
    #vist login path
    get login_path
    # post valid login creds
    post login_path, params: { session: { email: @user.email,
                                       password:  'password'
                                       }}

    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "log out logged in user" do
    get login_path
    post login_path, params: {session: { email: @user.email,
                                         password: 'password'}}
    assert_redirected_to @user
    follow_redirect!
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    get login_path
    post login_path, params: {session: { email: @user.email,
                                         password: 'password',
                                         remember_me: '1'}}
    follow_redirect!
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # Log in to set the cookie.
    get login_path
    post login_path, params: {session: { email: @user.email,
                                         password: 'password',
                                         remember_me: '0'}}
    follow_redirect!
    assert cookies['remember_token'].nil?
  end
end
