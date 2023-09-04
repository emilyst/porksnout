# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"

Bundler.require(*Rails.groups)

module Porksnout
  class Application < Rails::Application
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq

    config.active_record.schema_format = :sql

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework nil
    end
  end
end
