# Redmine Out of Band Auth

[![Build Status](https://travis-ci.org/matsukei/redmine_out_of_band_auth.svg?branch=master)](https://travis-ci.org/matsukei/redmine_out_of_band_auth)

Redmine plugin that provides Out of Band authentication by email.

## Usage

* Check the `Enable out of band authentication` checkbox on the `Administrator > Users > username` or `My account page`.
  * Will send a `verification code` to the default notification email address from the next login.
* If you want to encrypt the `verification code`, register `database_cipher_key` in `your_redmine_path/config/configuration.yml` .
  * If you are already registering SCM or LDAP password, please carefully read the notes in `your_redmine_path/config/configuration.yml`, such as by running `rake db:encrypt RAILS_ENV=production` .

## Screenshot

*Out of Band Authentication*

![out_of_band_auth](https://user-images.githubusercontent.com/943541/27113242-b8037c56-50f6-11e7-9164-8f894a9568da.png)

*My account*

![my_account](https://user-images.githubusercontent.com/943541/27113251-bcd7bb5c-50f6-11e7-8510-93449c68897f.png)

*Verification code*

![verification_code](https://user-images.githubusercontent.com/943541/27115125-84d8007e-5103-11e7-9a9c-8f676eaa3aad.png)

## Install

1. git clone or copy an unarchived plugin to plugins/redmine_out_of_band_auth on your Redmine path.
2. `$ cd your_redmine_path`
3. `$ bundle install`
4. `$ bundle exec rake redmine:plugins:migrate NAME=redmine_out_of_band_auth RAILS_ENV=production`
5. web service restart

## Uninstall

1. `$ cd your_redmine_path`
2. `$ bundle exec rake redmine:plugins:migrate NAME=redmine_out_of_band_auth RAILS_ENV=production VERSION=0`
3. remove plugins/redmine_out_of_band_auth
4. web service restart

## License

[The MIT License](https://opensource.org/licenses/MIT)
