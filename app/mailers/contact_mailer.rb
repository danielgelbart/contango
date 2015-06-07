class ContactMailer < ActionMailer::Base
  default from: "help@publicsecurities.com"

  def welcome_email(to_mail)
    @url  = 'http://example.com/login'
    #this creates the actual mail to be sent
    mail(to: to_mail, subject: 'Welcome to My Awesome Site')
  end
end
