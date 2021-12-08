class ArticlesController < ApplicationController
  # before_action :authenticate_user!, except: [:index, :show]

  before_action :after_token_authentication, except: [:index, :show]

  def after_token_authentication
    if params[:authentication_token].present?
      @user = User.find_by_authentication_token(params[:authentication_token])
      sign_in @user if @user
    end
  end

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
    # current_user from pundit
    @article = current_user.articles.new(article_params)
    
    authorize @article
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

    # p @article
    authorize @article

    if @article.update(article_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize @article
    @article.destroy

    head :no_content
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
