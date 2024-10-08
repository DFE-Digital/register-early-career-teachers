class Admin::Migration::TeachersController < AdminController
  layout "full"

  def index
    @teachers = Teacher.order(trn: 'asc')
  end

  def show
    @ecf_1_teacher = Migration::User.with_trn(params[:id])
    @ecf_1_induction_records = @ecf_1_teacher
      .teacher_profile
      .participant_profiles
      .flat_map(&:induction_records)

    @ecf_2_teacher = Teacher.find_by(trn: params[:id])
  end
end
