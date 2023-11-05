require 'http'
class WebhookWorker 
  include Sidekiq::Worker
  def perform(webhook_event_id)
    webhook_event = WebhookEvent.find(webhook_event_id)
    webhook_endpoint = webhook_event.webhook_endpoint
    if webhook_event.present? && webhook_endpoint.present?
      response = HTTP.headers('Content-Type' => 'application/json')
                    .post(
                      webhook_endpoint.url, 
                      body: {
                        secret_key: 'password'
                        event: webhook_event.event,
                        payload: webhook_event.payload,
                      }.to_json
                   )
      raise FailedRequestError unless
        response.status.success?
    end
  end

  private
  class FailedRequestError < StandardError; end
end