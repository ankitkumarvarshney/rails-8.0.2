module Api
  module V1
    class PostsController < Api::BaseController
      before_action :authorize_owner, only: [:update, :destroy]
      def index
        render json: Post.includes(:user).order(updated_at: :desc).as_json(
          include: { user: { only: [:id, :email] } },
          except: [:created_at, :updated_at]
        )
      end

      def create
        post = @current_user.posts.create!(post_params)
        render json: post.as_json(
          include: { user: { only: [:id, :email] } },
          except: [:created_at, :updated_at]
        ), status: :created
      end

      def show
        render json: Post.includes(:user).find(params[:id]).as_json(
          include: { user: { only: [:id, :email] } },
          except: [:created_at, :updated_at]
        )
      end

      def update
        post = Post.find(params[:id])
        post.update!(post_params)
        render json: post.as_json(
          include: { user: { only: [:id, :email] } },
          except: [:created_at, :updated_at]
        )
      end

      def destroy
        Post.find(params[:id]).destroy
        head :no_content
      end

      def authorize_owner
        post = Post.find(params[:id])
        unless post.user == @current_user
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end

    private

      def post_params
        params.require(:post).permit(:title, :content)
      end
    end
  end
end
