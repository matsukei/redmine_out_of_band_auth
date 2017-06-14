module OutOfBandAuth
  class UserPreferenceViewHooks < Redmine::Hook::ViewListener
    render_on :view_my_account_preferences, partial: 'out_of_band_auths/preferences'
    render_on :view_users_form_preferences, partial: 'out_of_band_auths/preferences'
  end
end
