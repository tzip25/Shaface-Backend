class UsersController < ApplicationController

    def create
      user = User.new(
        email: params[:email],
  			first_name: params[:firstName],
        last_name: params[:lastName],
  			username: params[:username].downcase,
  			password: params[:password]
  		)
  		if user.save
  			token = encode_token(user.id)
        render json: {user: user, token: token}
  		else
  			render json: {errors: user.errors.full_messages}
  		end
    end


    def update
      curr_user.update(first_name: params["first_name"], last_name: params["last_name"], email: params["email"], username: params["username"])
      render json: curr_user
    end

end
