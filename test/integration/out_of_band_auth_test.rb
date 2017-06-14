require File.expand_path('../../test_helper', __FILE__)

class OutOfBandAuthTest < Redmine::IntegrationTest
  include Redmine::I18n

  fixtures :users, :email_addresses, :user_preferences, :roles,
    :projects, :members, :member_roles, :issues, :issue_statuses,
    :trackers, :enumerations, :custom_fields, :auth_sources, :queries

  def setup
    User.current = nil
    ActionMailer::Base.deliveries.clear
  end

  def test_check_out_of_band_auth_with_not_password_auth_and_not_must_change_password
    assert !User.current.logged?

    get '/out_of_band_auths/login'
    assert_redirected_to "/login?back_url=http%3A%2F%2F#{@request.host}%2Fout_of_band_auths%2Flogin"

    get '/my/page'
    assert_redirected_to "/login?back_url=http%3A%2F%2F#{@request.host}%2Fmy%2Fpage"

    post '/logout'
    assert_redirected_to home_url
  end

  def test_check_out_of_band_auth_with_password_auth_and_not_must_change_password
    user = User.find(2) # jsmith
    user.must_change_passwd = false
    user.save!

    [ '0', '1' ].each do |value|
      user.pref.enabled_out_of_band_auth = value
      user.pref.save!

      assert_login('jsmith', 'jsmith')

      if user.enabled_out_of_band_auth?
        assert_response_for_enabled_out_of_band_auth
      else
        assert_response_for_disabled_out_of_band_auth
      end

      post '/logout'
      assert_redirected_to home_url
    end
  end

  def test_check_out_of_band_auth_with_password_auth_and_must_change_password
    user = User.find(2) # jsmith
    user.must_change_passwd = true
    user.save!

    [ '0', '1' ].each do |value|
      user.pref.enabled_out_of_band_auth = value
      user.pref.save!

      assert_login('jsmith', 'jsmith')

      get '/my/page'
      assert_redirected_to '/my/password'

      get '/out_of_band_auths/login'
      assert_redirected_to '/my/password'

      post '/logout'
      assert_redirected_to home_url
    end
  end

  def test_post_login
    user = User.find(2) # jsmith
    user.must_change_passwd = false
    user.save!

    user.pref.enabled_out_of_band_auth = '1'
    user.pref.save!

    assert_login('jsmith', 'jsmith')
    assert_verification_code_mail(user)

    # invalid verification code
    post '/out_of_band_auths/login', password: 'dummy verification code'
    assert_response :success
    assert_include 'Verification code is invalid', response.body
    assert_select 'h2', 'Out of Band Authentication'
    assert_response_for_enabled_out_of_band_auth

    # valid verification code
    post '/out_of_band_auths/login', password: User.current.verification_code
    assert_redirected_to '/my/page'
    assert_response_for_disabled_out_of_band_auth
  end

  def test_verification_code_changes_with_each_login
    verification_codes = []

    # dlopper, rhill, someone
    [ 3, 4, 7 ].each do |user_id|
      user = User.find(user_id)
      user.must_change_passwd = false
      user.save!

      user.pref.enabled_out_of_band_auth = '1'
      user.pref.save!

      3.times do |i|
        assert_login(user.login, 'foo')
        assert_verification_code_mail(user)
        verification_codes << user.verification_code
      end
    end

    # e.g. ["309981", "600116", "553776", "545553", "852046", "501467", "371304", "322618", "845179"]
    assert_equal 9, verification_codes.count
    assert_equal 9, verification_codes.uniq.count
  end

end
