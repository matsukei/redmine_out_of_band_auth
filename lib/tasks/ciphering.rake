Rake.application.instance_variable_get(:@tasks).delete('db:encrypt')
Rake.application.instance_variable_get(:@tasks).delete('db:decrypt')

namespace :db do
  desc 'Encrypts SCM and LDAP passwords and Out of Band auth codes in the database.'
  task encrypt: :environment do
    unless (Repository.encrypt_all(:password) &&
      AuthSource.encrypt_all(:account_password) &&
      AuthSourceOutOfBand.encrypt_all(:verification_code))
      raise "Some objects could not be saved after encryption, update was rolled back."
    end
  end

  desc 'Decrypts SCM and LDAP passwords and Out of Band auth codes in the database.'
  task decrypt: :environment do
    unless (Repository.decrypt_all(:password) &&
      AuthSource.decrypt_all(:account_password) &&
      AuthSourceOutOfBand.decrypt_all(:verification_code))
      raise "Some objects could not be saved after decryption, update was rolled back."
    end
  end
end
