# frozen_string_literal: true
class KafkaHandleEventConsumer < ApplicationConsumer
  # rubocop:disable I18n/Coverage/StaticString
  def consume
    p "Start consuming"
    message = JSON.parse(params.raw_payload)
    message['topic_type'] = params.topic
    
    p message
    # Call to config/initialized/kafka_handle_event
    KafkaHandleEvent.handle_event(message)
    
  rescue => e
    puts "Error: #{e.message}"
  end
end
