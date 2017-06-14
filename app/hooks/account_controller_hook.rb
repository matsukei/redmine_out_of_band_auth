module OutOfBandAuth
  class AccountControllerHooks < Redmine::Hook::ViewListener
    def controller_account_success_authentication_after(context = {})
      user, request = context.values_at(:user, :request)

      if user.enabled_out_of_band_auth?
        request.session[:oob] = '1'

        user.generate_verification_code
        OutOfBandAuthMailer.verification_code(user).deliver
      end
    end

  end
end
