# frozen_string_literal: true

module Porkbun
  class CertificateBundle < ApplicationRecord
    belongs_to :porkbun_domain, class_name: "Porkbun::Domain", optional: false
  end
end
