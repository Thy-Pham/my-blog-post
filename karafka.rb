# # frozen_string_literal: true

# # Ruby on Rails setup
# # Remove whole non-Rails setup that is above and uncomment the 4 lines below
# ENV['RAILS_ENV'] ||= 'development'
# # Please use karafka env values in this array https://github.com/karafka/karafka/blob/82b241d9eb3427411267b72d19bfc332e3433ebf/lib/karafka/instrumentation/logger.rb#L9
# ENV['KARAFKA_ENV'] ||= 'development'

# require ::File.expand_path('../config/environment', __FILE__)
# Rails.application.eager_load!

# if Rails.env.development?
#   Rails.logger.extend(
#     ActiveSupport::Logger.broadcast(
#       ActiveSupport::Logger.new($stdout)
#     )
#   )
# end

# class KarafkaApp < Karafka::App
#   setup do |config|
#     # if ENV['KAFKA_BROKERS']
#     #   config.kafka.seed_brokers = ENV['KAFKA_BROKERS'].split(',')
#     # else
#       config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
#     # end
#     config.client_id = 'example_app'
#     config.logger = Rails.logger
#   end

#   Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
#   Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)

#   consumer_groups.draw do
#     topic 'EmploymentHero.AdminProducer' do
#       consumer ::KafkaHandleEventConsumer
#     end
#   end
# end

# Karafka.monitor.subscribe('app.initialized') do
#   # Put here all the things you want to do after the Karafka framework
#   # initialization
# end

# KarafkaApp.boot!



# frozen_string_literal: true

# rubocop:disable I18n/Coverage/StaticString
ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= 'development'

KAFKA_BROKERS = ENV['KAFKA_BROKERS'] || 'kafka://127.0.0.1:9092'
CLIENT_ID = 'ats'

require ::File.expand_path('config/environment', __dir__)
Rails.application.eager_load!

class ConsumerMapper
  def self.call(raw_consumer_group_name)
    [
      Karafka::App.config.client_id,
      raw_consumer_group_name
    ].join('.')
  end
end

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    # config.kafka.seed_brokers = KAFKA_BROKERS.to_s.split(',')
    config.consumer_mapper = ConsumerMapper
    config.client_id = CLIENT_ID
    config.batch_fetching = false
    config.batch_consuming = false

    # config.kafka.ssl_verify_hostname = false
  end

  # Initialize karafka's base worker
  Class.new(Karafka::BaseWorker)

  consumer_groups.draw do
    ::KafkaHandleEvent.topics.each do |topic_name|
      topic topic_name do
        consumer ::KafkaHandleEventConsumer
        start_from_beginning false
        interchanger EncodingInterchanger.new
        # backend :sidekiq
      end
    end
  end
end

# module Raven
#   module Karafka
#     module Listener
#       class << self
#         # All the events in which something went wrong trigger the *_error
#         # method, so we can catch all of them and notify Sentry about that.
#         #
#         # @param method_name [Symbol] name of a method we want to run
#         # @param args [Array] arguments of this method
#         # @param block [Proc] additional block of this method
#         def method_missing(method_name, *args, &block)
#           return super unless method_name.to_s.end_with?('_error')

#           exception = StandardError.new(
#             "#{method_name.to_s.sub(/^on_/, '').humanize}: #{args.last[:error]}"
#           )
#           exception.set_backtrace(caller)
#           raise exception
#         rescue StandardError => e
#           Raven.capture_exception e unless e.message.match?(/PG::ConnectionBad/)
#         end

#         # @param method_name [Symbol] name of a method we want to run
#         # @return [Boolean] true if we respond to this missing method
#         def respond_to_missing?(method_name, include_private = false)
#           method_name.to_s.end_with?('_error') || super
#         end
#       end
#     end
#   end
# end

Karafka.monitor.subscribe('app.initialized') do
  WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
end

# Karafka.monitor.subscribe(Raven::Karafka::Listener)

# # Code reload in development mode
# Karafka.monitor.subscribe(Karafka::CodeReloader.new(*Rails.application.reloaders))

KarafkaApp.boot!
# rubocop:enable I18n/Coverage/StaticString
