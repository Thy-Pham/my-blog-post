class CommentsController < ApplicationController
    # http_basic_authenticate_with name: "pnmthy", password: "123", except: [:index, :show]

    def index
      @article = Article.find(params[:article_id])
      @comment = @article.comments.all
      render json: @comment, status: :ok
    end

    def create
        @article = Article.find(params[:article_id])
        # @comment = @article.comments.create!(comment_params)
        @comment = @article.comments.new(comment_params)
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        @comment.destroy
    
        head :no_content
    end
    
    private
      def comment_params
        params.require(:comment).permit(:commenter, :body, :status)
      end
end
