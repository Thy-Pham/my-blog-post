# frozen_string_literal: true
class KafkaHandleEventConsumer < ApplicationConsumer
  # rubocop:disable I18n/Coverage/StaticString
  def consume
    p "Start consuming"
    message = JSON.parse(params.raw_payload)
    message['topic_type'] = params.topic
    p message
    KafkaHandleEvent.handle_event(message.to_h.symbolize_keys)
    
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error("ERROR in #{self.class.name}#consume: #{e.message}")
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error("ERROR in #{self.class.name}#consume: #{e.message}")
    Raven.capture_exception(e)
  end
  # rubocop:enable I18n/Coverage/StaticString
end
