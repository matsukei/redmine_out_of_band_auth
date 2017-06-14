require_dependency 'mailer'

class OutOfBandAuthMailer < Mailer
  def verification_code(user)
    @message = l(:mail_body_verification_code, code: user.verification_code)
    title = l(:mail_subject_verification_code, value: Setting.app_title)

    mail(to: user.mail, subject: title)
  end

end
