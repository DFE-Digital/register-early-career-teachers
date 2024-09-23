# frozen_string_literal: true

module GIAS
  module Helpers
    extend ActiveSupport::Concern
    include GIAS::Types

    included do
      scope :cip_only, -> { open.where(type_code: GIAS::Types::CIP_ONLY_TYPE_CODES) }
      scope :eligible_for_registration, -> { open.in_england.where(type_code: GIAS::Types::ELIGIBLE_TYPE_CODES).or(open.in_england.section_41) }
      scope :in_england, -> { where("administrative_district_code ILIKE 'E%' OR administrative_district_code = '9999'") }
      scope :open, -> { open_status.or(proposed_to_close_status) }
      scope :section_41, -> { where(section_41_approved: true) }
    end

    def closed?
      !open?
    end

    def in_england?
      english_district?(administrative_district_code)
    end

    def open?
      open_status? || proposed_to_close_status?
    end
  end
end
