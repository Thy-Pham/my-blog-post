class ArticlesController < ApplicationController
  # http_basic_authenticate_with name: "pnmthy", password: "123", except: [:index, :show]
            
  # Add exception handler missing parameter
  # rescue_from ActionController::ParameterMissing, with: :parameter_missing
  
  def index
    @articles = Article.all
    render json: @articles, status: :ok
  end

  def show
    @article = Article.find(params[:id])
    render json: @article, status: :ok
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    head :no_content
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
