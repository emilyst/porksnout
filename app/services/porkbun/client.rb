# frozen_string_literal: true

require "erb"
require "faraday"

module Porkbun
  # @see https://porkbun.com/api/json/v3/documentation
  class Client
    include ERB::Util

    # @return [Faraday::Connection]
    attr_reader :connection

    # @param [String] url
    # @param [String] apikey
    # @param [String] secretapikey
    def initialize(apikey:, secretapikey:, url: "https://porkbun.com/api/json/v3/")
      @connection = Faraday.new(url:) do |connection|
        connection.use(AuthenticationMiddleware, apikey:, secretapikey:)
        connection.headers[:content_type] = "application/json"
        connection.request :json
        connection.request :retry
        connection.response :json, parser_options: { symbolize_names: true }
        connection.response :raise_error
        connection.response :logger, Rails.logger, {
          log_level: :debug,
          bodies: Rails.env.development?,
          headers: Rails.env.development?,
          errors: true,
        }
      end
    end

    class AuthenticationMiddleware < Faraday::Middleware
      # @param [Faraday::Env]
      def on_request(env)
        return unless env.method == :post

        env.body = case env.body
                   when Hash
                     env.body.merge(**options)
                   when String
                     JSON.parse(env.body).merge(**options)
                   else
                     options
                   end
      end
    end

    # @return [Faraday::Response]
    def ping
      connection.post("ping")
    end

    # @return [Faraday::Response]
    def get_ssl_bundle(domain:)
      connection.post("ssl/retrieve/#{domain}")
    end

    # @return [Faraday::Response]
    def edit_nameservers!(domain:, nameservers:)
      raise ArgumentError, "Nameservers must be an Array!" unless nameservers.is_a?(Array)

      connection.post("domain/updateNS/#{domain}", { ns: nameservers })
    end

    # @return [Faraday::Response]
    def create_record!(domain:, type:, content:, name: nil, ttl: nil, prio: nil)
      connection.post(
        "https://porkbun.com/api/json/v3/dns/create/#{domain}",
        {
          type:,
          content:,
          name:,
          ttl:,
          prio:,
        },
      )
    end

    # @return [Faraday::Response]
    def get_record(domain:, id:)
      connection.post("dns/retrieve/#{domain}/#{id}")
    end

    # @return [Faraday::Response]
    def get_records(domain:, type: nil, name: nil)
      connection.post(
        case [domain, type, name]
        in [String, nil, nil]
          "dns/retrieve/#{domain}"
        in [String, String, String]
          "dns/retrieveByNameType/#{domain}/#{type}/#{url_encode(name)}"
        else
          raise ArgumentError, "Must specify domain alone, or with type and name!"
        end,
      )
    end

    # @return [Faraday::Response]
    def edit_record!(domain:, id:, type:, content:, name: nil, ttl: nil, prio: nil)
      connection.post(
        "https://porkbun.com/api/json/v3/dns/edit/#{domain}/#{id}",
        {
          name:,
          type:,
          content:,
          ttl:,
          prio:,
        },
      )
    end

    # @return [Faraday::Response]
    def edit_records!(domain:, type:, content:, name: nil, ttl: nil, prio: nil)
      connection.post(
        "https://porkbun.com/api/json/v3/dns/editByNameType/#{domain}",
        {
          name:,
          type:,
          content:,
          ttl:,
          prio:,
        },
      )
    end

    # @return [Faraday::Response]
    def delete_records!(domain:, type: nil, name: nil)
      connection.post(
        case [domain, type, name]
        in [String, nil, nil]
          "dns/delete/#{domain}"
        in [String, String, String]
          "dns/deleteByNameType/#{domain}/#{type}/#{url_encode(name)}"
        else
          raise ArgumentError, "Must specify domain alone, or with type and name!"
        end,
      )
    end
  end
end
