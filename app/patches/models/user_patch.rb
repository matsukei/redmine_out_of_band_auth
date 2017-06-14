require_dependency 'user'

module OutOfBandAuth
  module UserPatch
    extend ActiveSupport::Concern
    unloadable

    included do
      unloadable

      def enabled_out_of_band_auth?
        self.pref.enabled_out_of_band_auth == '1'
      end

      def auth_source_out_of_band
        AuthSourceOutOfBand.find_or_create_by(user_id: self.id)
      end

      def verification_code
        self.auth_source_out_of_band.verification_code
      end

      def verification_code=(arg)
        oob = self.auth_source_out_of_band
        oob.verification_code = arg
        oob.save
      end

      def generate_verification_code
        self.verification_code = (100000..999999).to_a.sample
      end

      def clear_verification_code
        self.verification_code = nil
      end

      def valid_verification_code?(code)
        return false if code.blank?
        return self.verification_code == code
      end

    end
  end
end

OutOfBandAuth::UserPatch.tap do |mod|
  User.send :include, mod unless User.include?(mod)
end
