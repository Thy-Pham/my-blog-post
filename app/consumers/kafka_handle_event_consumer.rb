# frozen_string_literal: true

class KafkaHandleEventConsumer < ApplicationConsumer
  # rubocop:disable I18n/Coverage/StaticString
  def consume
    p "HELLO"
    message = params['payload']
    message['topic_type'] = params['topic']
    Karafka.logger.info message
    KafkaHandleEvent.handle_event(message)
    
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error("ERROR in #{self.class.name}#consume: #{e.message}")
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error("ERROR in #{self.class.name}#consume: #{e.message}")
    Raven.capture_exception(e)
  end
  # rubocop:enable I18n/Coverage/StaticString
end
