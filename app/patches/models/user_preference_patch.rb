require_dependency 'user_preference'

module OutOfBandAuth
  module UserPreferencePatch
    extend ActiveSupport::Concern
    unloadable

    included do
      unloadable
      include Redmine::SafeAttributes

      safe_attributes 'enabled_out_of_band_auth'
    end

    def enabled_out_of_band_auth; self[:enabled_out_of_band_auth] || '0'; end
    def enabled_out_of_band_auth=(value); self[:enabled_out_of_band_auth]=value; end

  end
end

OutOfBandAuth::UserPreferencePatch.tap do |mod|
  UserPreference.send :include, mod unless UserPreference.include?(mod)
end
