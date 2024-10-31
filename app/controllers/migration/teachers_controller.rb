class Migration::TeachersController < ::AdminController
  layout "full"

  def show
    @page = params[:page] || 1
    @teacher = Teacher.find_by(trn: params[:trn])
    @user = Migration::User.joins(:teacher_profile).where(teacher_profile: { trn: @teacher.trn }).first
    ect_periods = @teacher.ect_at_school_periods.order(:started_on)
    @ect_records = if ect_periods.any?
                     map_induction_records_to_school_periods(@user.teacher_profile.participant_profiles.ect.first,
                                                             ect_periods)
                   else
                     []
                   end

    mentor_periods = @teacher.mentor_at_school_periods.order(:started_on)
    @mentor_records = if mentor_periods.any?
                        map_induction_records_to_school_periods(@user.teacher_profile.participant_profiles.mentor.first,
                                                                mentor_periods)
                      else
                        []
                      end
  end

private

  def map_induction_records_to_school_periods(participant_profile, school_periods)
    induction_records = InductionRecordSanitizer.new(participant_profile:)

    induction_records.map do |ir|
      start_school_period = school_periods.where(started_on: ir.start_date.to_date).first
      end_school_period = school_periods.where(finished_on: ir.end_date.to_date).first if ir.end_date.present?

      ssp = Migration::SchoolPeriodPresenter.new(start_school_period) if start_school_period.present?
      esp = Migration::SchoolPeriodPresenter.new(end_school_period) if end_school_period.present?

      {
        induction_record: ir,
        start_school_period: ssp,
        end_school_period: esp,
      }
    end
  end
end
