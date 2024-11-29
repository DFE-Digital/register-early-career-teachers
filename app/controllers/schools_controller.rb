require 'debug'

class SchoolsController < ApplicationController
  include Authorisation

  before_action :set_school

  def index
    @school = first_school_with_no_mentors_but_ects || first_school
  end

private

  def authorised?
    # FIXME: make this work with DfE Sign-in
    current_user.email == 'admin@example.com' || session[:school_urn].present?
  end

  def set_school
    # This is temporary. 'School' will be set once DfE signin hooked up
    # School in the session or first school with ects but no mentors or first school
    @school = (school_from_session || first_school_with_no_mentors_but_ects || first_school)
  end

  def school_from_session
    School.joins(:gias_school).find_by_urn(session[:school_urn])
  end

  def first_school_with_no_mentors_but_ects
    School.joins(:gias_school, :ect_at_school_periods)
          .left_joins(:mentor_at_school_periods)
          .where.not(ect_at_school_periods: { id: nil })
          .where(mentor_at_school_periods: { id: nil })
          .first
  end

  def first_school
    School.joins(:gias_school).first
  end
end
