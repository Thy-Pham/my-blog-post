class PublishArticleWorker
  include Sidekiq::Worker

  def perform(article_id)
    article = Article.find(article_id)
    p "Article #{article_id}"
    article.update(status: 'public')
    p "Article #{article_id} has status #{article_id.status}!!!"
  end
end
