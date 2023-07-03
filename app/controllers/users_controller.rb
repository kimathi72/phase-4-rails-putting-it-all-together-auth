class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    before_action :authorize, only: [:show]
    def create
        user = User.create(user_params)
        if user&.valid?     
            session[:user_id] = user.id
            render json: user, status: :created
            else
                render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end 
    end
    def show
        user = User.find_by(id: session[:user_id])
        render json: user
    end

    private
   
    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
      end
    
    def record_not_found
        render json: { error: "Article not found" }, status: :not_found
    end

    def user_params
        params.permit(:username,:password, :password_confirmation, :image_url, :bio)
    end
end
