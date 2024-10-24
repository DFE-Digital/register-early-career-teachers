class Migration::TeachersController < ::AdminController
  layout "full"

  def index
    @pagy, @teachers = pagy(Teacher.order(last_name: :asc, first_name: :asc, id: :asc))
  end

  def show
    @page = params[:page] || 1
    @teacher = Teacher.find(params[:id])
    @user = Migration::User.joins(:teacher_profile).where(teacher_profile: { trn: @teacher.trn }).first
    if @teacher.ect_at_school_periods.any?
      @ect_records = InductionRecordSanitizer.new(@user.participant_profiles.ect.first)
    else
      @ect_records = []
    end

    if @teacher.mentor_at_school_periods.any?
      @mentor_records = InductionRecordSanitizer.new(@user.participant_profiles.mentor.first)
    else
      @mentor_records = []
    end
    # user = Struct.new(:id, :full_name)
    # @user = user.new(id: "123", full_name: "Arthur Trousers")
  end
end
