class ConfirmationController < ApplicationController
	def resend
		@user = User.new
		respond_to do |format|
		format.html
		end
	end

	def resend_create
		@user = User.find_by_email(params[:email])
		if @user
			generate_confirmation_token(@user)
			if @user.save
				UserMailer.confirm_account(@user).deliver
				redirect_to '/login', notice: "An email has been sent to #{@user.email}. Please follow instructions to verify your account."
			else
				flash.now[:alert] = 'Could not save user! Try again.'
				render 'resend'
			end
		else
			flash.now[:alert] = "User does not exist! Please enter a valid email or sign up for a new account."
			render 'resend'
		end
	end

	private
	def generate_confirmation_token(user)
		@user = user
		@user.confirmed = false
		@user.confirmation_token = SecureRandom.urlsafe_base64(16)
	end
end
