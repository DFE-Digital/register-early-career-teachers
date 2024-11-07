# frozen_string_literal: true

module Schools
  class ECTPresenter
    def initialize(attributes = {})
      @dynamic_attr_readers = []
      flattened_attributes = flatten_hash(attributes)
      flattened_attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
        # attr_readers are dynamically generated with the pattern [wizard_step]_[attribute]
        # e.g find_ect_trn
        self.class.attr_reader(key) unless self.class.method_defined?(key)
        @dynamic_attr_readers << key
      end

      return if @dynamic_attr_readers.empty?

      self.class.send(:private, *@dynamic_attr_readers)
    end

    def full_name
      "#{find_ect_first_name} #{find_ect_last_name}"
    end

    def govuk_date_of_birth
      find_ect_date_of_birth.to_date.to_formatted_s(:govuk)
    end

    def trn
      find_ect_trn
    end

    def email
      email_address_email
    end

  private

    def flatten_hash(hash, parent_key = "")
      hash.each_with_object({}) do |(key, value), result|
        full_key = [parent_key, key].reject(&:empty?).join("_")
        if value.is_a?(Hash)
          result.merge!(flatten_hash(value, full_key))
        else
          result[full_key] = value
        end
      end
    end
  end
end
