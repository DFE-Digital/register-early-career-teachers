# frozen_string_literal: true

class TeacherReferenceNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    teacher_ref_number = Schools::Validation::TeacherReferenceNumber.new(value)
    unless teacher_ref_number.valid?
      message_scope = "errors.teacher_reference_number"
      record.errors.add(attribute, I18n.t(teacher_ref_number.format_error, scope: message_scope))
    end
  end
end
