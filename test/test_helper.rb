# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

def assert_login(username, password)
  post '/login', username: username, password: password
  assert_redirected_to '/my/page'
end

def assert_verification_code_mail(user)
  mail = ActionMailer::Base.deliveries.last
  assert_not_nil mail
  # bcc_recipients
  assert_include user.mail, mail.to + mail.bcc
  assert_equal mail.subject, l(:mail_subject_verification_code, value: Setting.app_title)
end

def assert_response_for_disabled_out_of_band_auth
  get '/my/page'
  assert_response :success
  assert_select 'h2', 'My page'

  get '/out_of_band_auths/login'
  assert_redirected_to home_url
end

def assert_response_for_enabled_out_of_band_auth
  get '/my/page'
  assert_redirected_to '/out_of_band_auths/login'

  get '/out_of_band_auths/login'
  assert_response :success
  assert_select 'h2', 'Out of Band Authentication'
end
