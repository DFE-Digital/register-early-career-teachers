require "rails_helper"

RSpec.describe "Admin assigns user roles" do
  include UserHelper

  scenario "when the user has no roles" do
    given_i_am_logged_in_as_an_admin
    and_there_are_roles_which_can_be_assigned
    and_there_is_a_user_with_no_roles
    when_i_visit_the_user_roles_page
    and_i_choose_the_appropriate_body_role_type
    and_i_assign_roles_to_the_user
    then_the_user_has_the_appropriate_roles
  end

  scenario "when the user has existing roles" do
    given_i_am_logged_in_as_an_admin
    and_there_are_roles_which_can_be_assigned
    and_there_is_a_user_with_roles
    when_i_visit_the_user_roles_page
    and_i_choose_the_appropriate_body_role_type
    and_i_uncheck_existing_roles
    and_i_assign_roles_to_the_user
    then_the_user_has_the_appropriate_roles
    and_i_choose_the_appropriate_body_role_type
    then_i_can_see_the_correct_roles_are_checked
  end

  def given_i_am_logged_in_as_an_admin
    sign_in_as_admin
  end

  def and_there_are_roles_which_can_be_assigned
    @appropriate_bodies = FactoryBot.create_list(:appropriate_body, 3)
  end

  def and_there_is_a_user
    @user = FactoryBot.create(:user)
  end
  alias_method :and_there_is_a_user_with_no_roles, :and_there_is_a_user

  def and_there_is_a_user_with_roles
    and_there_is_a_user
    @user.appropriate_bodies << @appropriate_bodies.second
  end

  def when_i_visit_the_user_roles_page
    page.goto role_type_admin_user_path(@user)
  end

  def and_i_choose_the_appropriate_body_role_type
    page.get_by_label("Appropriate body").check
    page.get_by_role("button", name: "Continue").click
  end

  def and_i_uncheck_existing_roles
    expect(page.get_by_text("Assign appropriate body roles to #{@user.name}")).to be_visible
    page.get_by_label(@appropriate_bodies.second.name).uncheck
  end

  def and_i_assign_roles_to_the_user
    expect(page.get_by_text("Assign appropriate body roles to #{@user.name}")).to be_visible
    page.get_by_label(@appropriate_bodies.first.name).check
    page.get_by_label(@appropriate_bodies.last.name).check
    page.get_by_role("button", name: "Save").click
  end

  def then_the_user_has_the_appropriate_roles
    expect(page.get_by_text("Current roles for #{@user.name}")).to be_visible
    expect(page.get_by_text(@appropriate_bodies.first.name)).to be_visible
    expect(page.get_by_text(@appropriate_bodies.last.name)).to be_visible
  end

  def then_i_can_see_the_correct_roles_are_checked
    expect(page.get_by_label(@appropriate_bodies.first.name)).to be_checked
    expect(page.get_by_label(@appropriate_bodies.second.name)).not_to be_checked
    expect(page.get_by_label(@appropriate_bodies.last.name)).to be_checked
  end
end
