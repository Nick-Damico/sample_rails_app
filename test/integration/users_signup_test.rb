require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                          email: "user@invalid.com",
                                          password:             "foo",
                                          password_confirmation: "bar"
                                          }}
    end
    assert_template 'users/new'
    assert_select "[action='/signup']"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup information results in new user" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'William',
                                          email: "will@valid.com",
                                          password:              'bestkitty',
                                          password_confirmation: 'bestkitty'
                                          }}
    end
    follow_redirect!
    assert_template "users/show"
    # assert_select "div.alert", "Welcome to the Sample App!"
    assert_not flash.empty?
  end
end
