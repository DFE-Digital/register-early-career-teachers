class InductionRecordSanitizer
  include Enumerable

  class InductionRecordError < StandardError; end
  class MultipleBlankEndDateError < InductionRecordError; end
  class MultipleActiveStatesError < InductionRecordError; end
  class StartDateAfterEndDateError < InductionRecordError; end
  class InvalidDateSequenceError < InductionRecordError; end

  attr_reader :participant_profile

  def initialize(participant_profile:)
    @participant_profile = participant_profile
  end

  def validate!
    # TODO: add more validation checks here as we discover them
    does_not_have_multiple_blank_end_dates!
    does_not_have_multiple_active_induction_statuses!
    induction_record_dates_are_sequential!
  end

  def validate_and_compress!
    validate!

    last_induction_record = nil
    induction_records.each_with_object([]) do |induction_record, result|
      if different?(induction_record, last_induction_record)
        result << induction_record
        last_induction_record = induction_record
      end
    end
  end

  def each
    return to_enum(__method__) { induction_records.size } unless block_given?

    induction_records.each do |induction_record|
      yield Migration::InductionRecordPresenter.new(induction_record)
    end
  end

private

  def induction_records
    @induction_records ||= participant_profile.induction_records.includes(induction_programme: [{ school_cohort: [:school] }]).order(start_date: :asc)
  end

  def different?(ir1, ir2)
    ignored_attrs = %w[id start_date end_date created_at updated_at].freeze

    return true if ir1.nil? || ir2.nil?

    ir1.attributes.except(*ignored_attrs) != ir2.attributes.except(*ignored_attrs)
  end

  def does_not_have_multiple_blank_end_dates!
    raise MultipleBlankEndDateError if induction_records.where(end_date: nil).count > 1
  end

  def does_not_have_multiple_active_induction_statuses!
    raise MultipleActiveStatesError if induction_records.where(induction_status: "active").count > 1
  end

  def induction_record_dates_are_sequential!
    previous_end_date = induction_records.first.end_date

    induction_records.each_with_index do |ir, idx|
      raise StartDateAfterEndDateError if ir.end_date.present? && ir.end_date < ir.start_date

      next if idx.zero?

      raise InvalidDateSequenceError if ir.start_date < previous_end_date

      previous_end_date = ir.end_date
    end
  end
end
