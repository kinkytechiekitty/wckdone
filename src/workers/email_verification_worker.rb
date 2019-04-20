require 'sendgrid-ruby'
require 'sidekiq'

class EmailVerificationWorker
  include Sidekiq::Worker
  include SendGrid

  def perform(user_id)
    user = User.find(id: user_id)
    from = Email.new(email: 'noreply@wckdone.com')
    to = Email.new(email: user.email)
    subject = 'WickedOne - Please verify your email address'
    content = Content.new(type: 'text/plain',
                          value: "https://wckdone.com/email/verify/#{user_id}/#{user.email_verification_token}")
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._('send').post(request_body: mail.to_json)
  end
end

