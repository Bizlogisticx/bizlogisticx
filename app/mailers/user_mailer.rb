class UserMailer < ActionMailer::Base
  default from: "confirmation@bizlogistix.com"

  def confirm_account(user)
  	@user = user
  	@url = "http://localhost:3000/users/#{@user.id}/confirm_account/#{@user.confirmation_token}"
  	mail(to: @user.email, subject: 'Confirm your Bizlogistix account')
  end

  def reset_password(user)
  	@user = user
  	@url = "http://localhost:3000/users/#{@user.id}/reset_password/#{@user.confirmation_token}" #edit_user_url(@user, :host => "localhost:3000")
  	mail(to: @user.email, subject: 'Reset your Bizlogistix.com password')
  end
end
