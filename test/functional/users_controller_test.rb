require File.expand_path('../../test_helper', __FILE__)

class OutOfBandAuth::UsersControllerTest < ActionController::TestCase
  tests UsersController

  fixtures :users, :email_addresses, :user_preferences, :roles,
    :projects, :members, :member_roles, :issues, :issue_statuses,
    :trackers, :enumerations, :custom_fields, :auth_sources, :queries

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_edit_should_display_enabled_oob_auth
    get :edit, { id: 2 }

    assert_response :success
    assert !User.find(2).enabled_out_of_band_auth?
    assert_select 'input[type="hidden"][name=?][value="0"]', 'pref[enabled_out_of_band_auth]'
    assert_select 'input[type="checkbox"][name=?][value="1"]:not([checked])', 'pref[enabled_out_of_band_auth]'
  end

  def test_update_enabled_oob_auth
    patch :update, {
      id: 2,
      user: {},
      pref: {
        enabled_out_of_band_auth: '1'
      },
    }

    assert_redirected_to '/users/2/edit'
    assert User.find(2).enabled_out_of_band_auth?
  end

end
