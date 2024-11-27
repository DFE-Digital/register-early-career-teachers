class TeacherReferenceNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    teacher_ref_number = Schools::Validation::TeacherReferenceNumber.new(value)
    unless teacher_ref_number.valid?
      record.errors.add(attribute, teacher_ref_number.format_error)
    end
  end
end
