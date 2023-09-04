# frozen_string_literal: true

module Porkbun
  class Record < ApplicationRecord
    belongs_to :porkbun_domain, class_name: "Porkbun::Domain", optional: false
  end
end
