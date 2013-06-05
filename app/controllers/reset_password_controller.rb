class ResetPasswordController < ApplicationController
  def password
  	@user = User.new
	respond_to do |format|
	format.html
	end
  end

  def password_create
  	@user = User.find_by_email(params[:email])

  	if @user
  		generate_confirmation_token(@user)
  		if @user.save
  			UserMailer.reset_password(@user).deliver
  			redirect_to '/login', notice: "An email has been sent to #{@user.email}. Please follow the instructions to reset your password."
  		else
  			flash.now[:alert] = 'User could not be saved! Please try again.'
  			render 'password'
  		end
  	else
  		flash.now[:alert] = 'User not found! Please try again or sign up for a new account.'
  		render 'password'
  	end
  end

  private
	def generate_confirmation_token(user)
		@user = user
		@user.confirmation_token = SecureRandom.urlsafe_base64(16)
	end
end
