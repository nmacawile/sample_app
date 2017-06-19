require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "layout links visibility (not logged in)" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
  
  test "layout links visibility (logged in)" do
    log_in_as(@user)
    follow_redirect!
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
  
  test "links to static pages" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title
    get contact_path
    assert_select "title", full_title("Contact")
    get help_path
    assert_select "title", full_title("Help")
    get about_path
    assert_select "title", full_title("About")
  end
  
  test "links to dynamic pages" do
    get new_user_path(@user)
    assert_template "users/new"
    get login_path(@user)
    assert_template "sessions/new"
    log_in_as(@user)
    
    get users_path
    assert_template "users/index"
    get user_path(@user)
    assert_template "users/show"
    get edit_user_path(@user)
    assert_template "users/edit"
  end
end