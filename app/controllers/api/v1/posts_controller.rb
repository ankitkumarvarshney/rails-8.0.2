module Api
  module V1
    class PostsController < Api::BaseController
      def index
        render json: Post.order(updated_at: :desc)
      end

      def create
        post = Post.create!(post_params)
        render json: post, status: :created
      end

      def show
        render json: Post.find(params[:id])
      end

      def update
        post = Post.find(params[:id])
        post.update!(post_params)
        render json: post
      end

      def destroy
        Post.find(params[:id]).destroy
        head :no_content
      end

    private

      def post_params
        params.require(:post).permit(:title, :content)
      end
    end
  end
end
