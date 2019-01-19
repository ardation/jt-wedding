# frozen_string_literal: true

class SmsGatewayMeService
  attr_reader :person, :phone, :message

  def self.send_message(phone, message)
    new(phone, message).send_message
  end

  def initialize(phone, message)
    @phone = phone.gsub(/\D/, '')
    @message = message.strip
  end

  def send_message
    raise 'no devices on sms_gateway_me' unless device_id

    messages = RestClient.post(
      'https://smsgateway.me/api/v4/message/send',
      [{
        phone_number: phone,
        message: message,
        device_id: device_id
      }].to_json,
      content_type: :json,
      authorization: ENV.fetch('SMS_GATEWAY_ME_API_KEY')
    )
    response_message = JSON.parse(messages).first&.with_indifferent_access
    { service_sid: response_message[:id], status: response_message[:status] }
  end

  private

  def device_id
    return @device_id if @device_id

    devices = RestClient.post(
      'https://smsgateway.me/api/v4/device/search',
      '',
      authorization: ENV.fetch('SMS_GATEWAY_ME_API_KEY')
    )
    JSON.parse(devices)['results'].sample&.dig('id')
  end
end
