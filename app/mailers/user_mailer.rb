class UserMailer < ActionMailer::Base
  default from: 'developers@muse.com'
 
  def create_and_deliver_password_change(user, random_password)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    @random_password  = random_password
    mail(to: email_with_name, subject: 'Muse: Restore Your Password')
  end
end
