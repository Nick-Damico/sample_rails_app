class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:session][:password])
    if @user && @user.authenticate(params[:session][:password])
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
end
