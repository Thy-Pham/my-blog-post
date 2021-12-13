class PublishArticleWorker
  include Sidekiq::Worker

  def perform(article_id)
    p "Article #{article_id} has been published!!!"
  end
end
