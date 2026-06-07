module Api
  module V1
    class AuthController < Api::BaseController
      skip_before_action :authenticate_request

      def register
        @user = User.create!(user_params)
        render json: { message: "User created successfully" }, status: :created
      end

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user.as_json(only: [ :id, :email ]) }, status: :created
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

    private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
