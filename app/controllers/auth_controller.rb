class AuthController < ApplicationController

  def login
    user = User.find_by(username: params[:username].downcase)
    
    if user && user.authenticate(params[:password])
      token = encode_token(user.id)
      render json: {user: user, token: token}
    else
      render json: {errors: "Invalid username or password"}
    end
  end


  def auto_login
    if curr_user
      render json: curr_user
    else
      render json: {errors: "Invalid username or password"}
    end
  end

end
