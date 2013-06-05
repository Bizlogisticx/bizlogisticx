require 'SecureRandom'
class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :authorize, :only => :index

  def index
    @users = User.all
    session[:prev] = '/users'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    generate_confirmation_token(@user)
    respond_to do |format|
      if @user.save
        format.html { redirect_to '/login', notice: "An email was sent to #{@user.email}. Please follow the instructions and confirm your account." }
        format.json { render json: @user, status: :created, location: @user }
        UserMailer.confirm_account(@user).deliver
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @old_password = @user.password
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if @user.email == session[:email] && @old_password == @user.password
          session[:prev] = '/users/my_account'
        elsif @old_password != @user.password
          format.html {redirect_to '/login', notice: 'Your password has been successfully changed!'}
        else
          format.html { redirect_to @user, notice: "User was updated successfully!" }
          format.json { head :no_content }
        end
        if !@user.confirmed
          UserMailer.confirm_account(@user).deliver
          flash[:notice] = "An email was sent to #{@user.email}. Please follow the instructions and confirm your account."
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def account
    @user = User.find_by_email(session[:email])
    unless @user
      flash[:notice] = 'Please login to access your account!'
      redirect_to '/login'
    end
  end

  def confirm_email
    @user = User.find(params[:id])
    if @user && params[:confirmation_token] == @user.confirmation_token
      @user.confirmed = true
      @user.confirmation_token = nil
      if @user.save
        redirect_to '/login', notice: 'Your account has been activated!'
      else
        redirect_to '/home', notice: 'User could not be saved!'
      end
    else
      redirect_to '/login', notice: %Q[Could not verify account. <a href="http://localhost:3000/reconfirm_account">Click here</a> to resend confirmation email.].html_safe #id = #{params[:id]}, pct = #{params[:confirmation_token]}, dbct = #{@user.confirmation_token}, conf = #{@user.confirmed}, name = #{@user.first}#{@user.last}
    end
  end

  def reset_password
    @user = User.find(params[:id])
    if @user && params[:confirmation_token] == @user.confirmation_token
      @user.confirmation_token = nil
      if @user.save
        session[:email] = @user.email
        redirect_to edit_user_path(@user)
      else
        redirect_to '/home', notice: 'User could not be saved!'
      end
    elsif session[:email]
      redirect_to '/users/my_account', notice: 'Link does not exist!'
    else
      redirect_to '/login', notice: "Password reset failed! Please try again."
    end
  end


  private
  def generate_confirmation_token(user)
    @user = user
    @user.confirmed = false
    @user.confirmation_token = SecureRandom.urlsafe_base64(16)
  end
end
