module Admin
  class RolesController < AdminController
    def index
      @roles_form = RolesForm.new(role_type_params.merge(user:))

      if role_type_params.to_h.any? && @roles_form.valid?
        redirect_to roles_admin_user_path(id: user.id, role_type: @roles_form.role_type)
      end
    end

    def edit
      @roles_form = RolesForm.new(user:, role_type:)
    end

    def update
      @roles_form = RolesForm.new(roles_params.merge(user:, role_type:))

      if @roles_form.valid? && @roles_form.save!
        redirect_to role_type_admin_user_path(@user)
      else
        render :edit
      end
    end

  private

    def role_type
      params[:role_type]
    end

    def role_type_params
      params.fetch(:admin_roles_form, {}).permit(:role_type)
    end

    def roles_params
      params.require(:admin_roles_form).permit(:role_type, role_ids: [])
    end

    def user
      @user = User.find(params[:id])
    end
  end
end
