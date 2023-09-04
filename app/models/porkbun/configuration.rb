# frozen_string_literal: true

module Porkbun
  class Configuration < ApplicationRecord
    has_many :porkbun_domains, class_name: "Porkbun::Domain", dependent: :destroy
  end
end
