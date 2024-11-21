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
                   else
                     nil
                   end
  end

  def mentor_profile
    @mentor_profile = if teacher.legacy_mentor_id.present?
                        Migration::ParticipantProfilePresenter.new(
                          Migration::ParticipantProfile.find(teacher.legacy_mentor_id)
                        )
                      else
                        nil
                      end
  end

  def user
    @user ||= Migration::User.find(teacher.legacy_id)
  end

  def teacher
    @teacher ||= Teacher.find_by(trn: params[:trn])
  end
end
