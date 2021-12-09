module V1
    class Comments < Grape::API
        namespace 'articles/:article_id' do
            params do
                requires :article_id, type: Integer
            end

            resource :comments do
                desc 'GET /v1/articles/:article_id/comments'
                get do
                    @article = Article.find(params[:article_id])
                    @comment = @article.comments.all
                    status :ok
                    @comment
                end

                desc 'POST /v1/articles/:article_id/comments'
                params do
                    requires :commenter, type: String
                    requires :body, type: String
                    requires :status, type: String
                end
                post do
                    @article = Article.find(params[:article_id])
                    @comment = @article.comments.new(params)
                    if @comment.save
                        status :created
                        @comment
                    else
                        status :unprocessable_entity
                        @comment.errors
                    end
                end

                desc 'DELETE /v1/articles/:article_id/comments/:id'
                params do
                    requires :id, type: Integer
                end
                delete ':id' do
                    @article = Article.find(params[:article_id])
                    @comment = @article.comments.find(params[:id])
                    @comment.destroy
                
                    status :no_content
                end
            end
        end
    end
end
