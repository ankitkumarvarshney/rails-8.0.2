module Api
  class BaseController < ActionController::API
    before_action :authenticate_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActionController::RoutingError, with: :routing_error
    rescue_from ActionController::UnknownFormat, with: :unknown_format

    def route_not_found
      raise ActionController::RoutingError.new("No route matches #{request.method} #{request.path}")
    rescue ActionController::RoutingError => e
      render json: { error: e.message }, status: :not_found
    end


    private

    def authenticate_request
      header = request.headers["Authorization"]
      header = header.split(" ").last if header

      decoded = JsonWebToken.decode(header)
      @current_user = User.find_by(id: decoded[:user_id]) if decoded

      render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
    end

    def record_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def record_invalid(exception)
      render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def parameter_missing(exception)
      render json: { error: exception.message }, status: :bad_request
    end

    def routing_error(exception)
      render json: { error: "Route not found: #{exception.message}" }, status: :not_found
    end

    def unknown_format(exception)
      render json: { error: "Unsupported format: #{exception.message}" }, status: :not_acceptable
    end
  end
end
