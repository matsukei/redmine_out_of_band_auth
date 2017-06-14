require_dependency 'application_controller'

module OutOfBandAuth
  module ApplicationControllerPatch
    extend ActiveSupport::Concern
    unloadable

    included do
      unloadable

      before_action :check_out_of_band_auth

      def check_out_of_band_auth
        return true if controller_name == 'account'
        return true if session[:pwd].present?

        if session[:oob]
          if User.current.enabled_out_of_band_auth?

            flash[:notice] = l(:notice_sent_verification_code, email: ERB::Util.h(User.current.mail))
            redirect_to controller: 'out_of_band_auths', action: 'login'
          else
            session.delete(:oob)
          end
        end
      end

    end

  end
end

OutOfBandAuth::ApplicationControllerPatch.tap do |mod|
  ApplicationController.send :include, mod unless ApplicationController.include?(mod)
end
