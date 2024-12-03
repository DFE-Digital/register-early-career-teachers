class Migration::TeachersController < ::AdminController
  layout "full"

  def show
    @page = params[:page] || 1
    fetch_teacher_data
  end

private

  def fetch_teacher_data
    teacher
    user
    ect_profile
    mentor_profile
    ect_school_periods
    mentor_school_periods
    failures
  end

  def failures
    @failures = Migration::MigrationFailurePresenter.wrap(
      MigrationFailure.where(parent_type: "Teacher", parent_id: @teacher.id)
    )
  end

  def ect_school_periods
    @ect_periods = Migration::SchoolPeriodPresenter.wrap(
      teacher.ect_at_school_periods.order(:started_on)
    )
  end

  def mentor_school_periods
    @mentor_periods = Migration::SchoolPeriodPresenter.wrap(
      teacher.mentor_at_school_periods.order(:started_on)
    )
  end

  def ect_profile
    @ect_profile = if teacher.legacy_ect_id.present?
                     Migration::ParticipantProfilePresenter.new(
                       Migration::ParticipantProfile.find(teacher.legacy_ect_id)
                     )
                   end
  end

  def mentor_profile
    @mentor_profile = if teacher.legacy_mentor_id.present?
                        Migration::ParticipantProfilePresenter.new(
                          Migration::ParticipantProfile.find(teacher.legacy_mentor_id)
                        )
                      end
  end

  def user
    @user ||= Migration::User.find(teacher.legacy_id)
  end

  def teacher
    @teacher ||= Admin::TeacherPresenter.new(Teacher.find_by(trn: params[:trn]))
  end
end
