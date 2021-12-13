# frozen_string_literal: true

# rubocop:disable I18n/Coverage/StaticString
ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= 'development'

KAFKA_BROKERS = ENV['KAFKA_BROKERS'] || 'kafka://127.0.0.1:9092'
CLIENT_ID = 'blog-post-client'

require ::File.expand_path('config/environment', __dir__)
Rails.application.eager_load!

# class ConsumerMapper
#   def self.call(raw_consumer_group_name)
#     [
#       Karafka::App.config.client_id,
#       raw_consumer_group_name
#     ].join('.')
#   end
# end

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    # config.consumer_mapper = ConsumerMapper
    config.client_id = CLIENT_ID
    config.batch_fetching = false
    config.batch_consuming = false # consume single message 
  end

  consumer_groups.draw do
    ::KafkaHandleEvent.topics.each do |topic_name|
      topic topic_name do
        consumer ::KafkaHandleEventConsumer
        start_from_beginning false
      end
    end
  end
end

Karafka.monitor.subscribe('app.initialized') do
  WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
end

KarafkaApp.boot!
# rubocop:enable I18n/Coverage/StaticString
