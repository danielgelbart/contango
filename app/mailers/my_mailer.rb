class MyMailer < ActionMailer::Base
  default from: "site@publicsecurities.com"

  def contact_email(contact)
    @contact = contact
    mail( :subject => "My Contact Form: #{contact.title}",
          :to => ENV["GMAIL_USERNAME"],
          :from => %("#{contact.name}" <#{contact.email}>) )

  end

end
