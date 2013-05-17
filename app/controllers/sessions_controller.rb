class SessionsController < ApplicationController
  def new
  	@user = User.new

	respond_to do |format|
   	format.html # new.html.erb
   	#format.json { render json: @user }
   	end
  end

  def create
  	@user = User.find_by_email(params[:email])
	if @user
		session[:first] = @user.first
		session[:email] = @user.email
		if @user.authenticate(params[:password])
			session[:user_id] = @user.id
			redirect_to '/users/my_account', notice: 'You are now logged in!'
		else
			flash.now.alert = 'Incorrect password! Please try again.'
			render 'new'
		end
	else
		redirect_to '/login', notice: 'Email not found! Please try again or register for a new account.'
	end
  end

  def destroy
  	session[:first] = nil
  	session[:user_id] = nil
	session[:email] = nil
	redirect_to '/login', notice: 'You have logged out of your account!'
  end
end
