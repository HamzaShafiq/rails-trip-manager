class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  protected

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        @current_user = User.find_by(api_key: token)
      end
    end

    def render_unauthorized
      render json: { message: 'Invalid Credentials' }, status: :unauthorized
    end
end
