require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  setup do
    @new_user = User.create!(name: 'Will', email: 'iamwill@valid.com',
                                             password: 'IamWill',
                                             password_confirmation: 'IamWill')
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
    post login_path, params: {session: {email: 'iamwill@valid.com', password: 'IamWill'}}
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
