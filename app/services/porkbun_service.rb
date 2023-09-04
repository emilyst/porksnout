# frozen_string_literal: true

class PorkbunService
  class Error < ::RuntimeError; end

  # @return [Porkbun::Configuration]
  attr_reader :configuration

  # @param [Porkbun::Configuration] configuration
  def initialize(configuration: nil)
    @configuration = configuration || Porkbun::Configuration.first!
  end

  delegate_missing_to :client

  private

  def ip_address
    client.ping.body[:yourIp]
  end

  def client
    @client ||= Porkbun::Client.new(
      url: configuration.url,
      apikey: configuration.api_key,
      secretapikey: configuration.secret_key,
    )
  end
end
