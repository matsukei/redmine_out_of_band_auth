class AuthSourceOutOfBand < ActiveRecord::Base
  include Redmine::Ciphering

  has_many :users

  def verification_code
    read_ciphered_attribute(:verification_code)
  end

  def verification_code=(arg)
    write_ciphered_attribute(:verification_code, arg)
  end
end
