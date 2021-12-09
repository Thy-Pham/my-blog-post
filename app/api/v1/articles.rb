module V1
    class Articles < Grape::API
        resources :articles do
            desc 'GET /v1/articles'
            get do
                @articles = Article.all
                status :ok
                @articles
            end

            desc 'GET /v1/articles/:id'
            params do
                requires :id, type: Integer, desc: 'article_id'
            end
            get ':id' do
                @article = Article.find(params[:id])
                p @article
                status :ok
                @article
            end

            desc 'POST /v1/articles'
            params do
                requires :title, type: String
                requires :body, type: String
                requires :status, type: String
            end
            post do
                p "CURRENT_USER",  current_user
                @article = current_user.articles.new(
                    title: params[:title],
                    body: params[:body],
                    status: params[:status]
                )
    
                
                authorize @article, :create?
                if @article.save
                    status :created
                    @article
                else
                    status :unprocessable_entity
                    @article.errors
                end
            end

            desc 'PUT /v1/articles/:id'
            params do
                requires :id, type: Integer
                optional :title, type: String
                optional :body, type: String
                optional :status, type: String
            end
            put ':id' do
                @article = Article.find(params[:id])
                authorize @article, :update?

                if @article.update(
                    title: params[:title] || @article.title,
                    body: params[:body] || @article.body,
                    status: params[:status] || @article.status
                )
                    status :ok
                    @article
                else
                    status :unprocessable_entity
                    @article.errors
                end
            end

            desc 'DELETE /v1/articles/:id'
            params do
                requires :id, type: Integer
            end
            delete ':id' do
                @article = Article.find(params[:id])
                authorize @article, :destroy?
                @article.destroy
            
                status :no_content
            end
        end

        mount V1::Comments => '/'
    end
end
