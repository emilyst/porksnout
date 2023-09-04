# frozen_string_literal: true

module Porkbun
  class Domain < ApplicationRecord
    belongs_to :porkbun_configuration, class_name: "Porkbun::Configuration", optional: false
    has_many :porkbun_records, class_name: "Porkbun::Record", dependent: :destroy
    has_many :porkbun_certificate_bundles, class_name: "Porkbun::CertificateBundle", dependent: :destroy
  end
end
