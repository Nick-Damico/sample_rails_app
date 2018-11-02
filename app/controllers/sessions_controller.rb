class SessionsController < ApplicationController
  # login_path render sessions/new.html.erb
  def new
    @user = User.new
  end

  # 'Post', login_path
  def create
    # Find User in db with params[:session][:password] from form submission, finding by email due to index
    @user = User.find_by(email: params[:session][:email])
    # User is found, has_secure_password #authenticate method
    if @user && @user.authenticate(params[:session][:password])
      # session[:user_id] set
      log_in(@user)
      # cookies[:user_id], cookies[:remember_token] set,
      # Should only be called if 'remember me' checkbox
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:notice] = "Welcome back #{@user.name}."
      redirect_to @user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = "Successfully Logged Out"
    redirect_to root_path
  end
end
