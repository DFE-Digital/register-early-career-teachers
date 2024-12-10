require "rails_helper"

RSpec.describe "Admin teachers index", type: :request do
  describe "GET /admin/teachers" do
    it "redirects to sign-in" do
      get "/admin/teachers"
      expect(response).to redirect_to(sign_in_path)
    end

    context "with an authenticated non-DfE user" do
      include_context 'fake session manager for non-DfE user'

      it "requires authorisation" do
        get "/admin/teachers"
        expect(response.status).to eq(401)
      end
    end

    context "with an authenticated DfE user" do
      include_context 'fake session manager for DfE user'

      context "with search query" do
        it "filters teachers by name" do
          teacher = FactoryBot.create(:teacher, first_name: "John", last_name: "Smith")
          other_teacher = FactoryBot.create(:teacher, first_name: "Jane", last_name: "Doe")

          FactoryBot.create(
            :induction_period,
            teacher: teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )
          FactoryBot.create(
            :induction_period,
            teacher: other_teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          get "/admin/teachers", params: { q: "John Smith" }

          expect(response.status).to eq(200)
          expect(response.body).to include("John Smith")
          expect(response.body).not_to include("Jane Doe")
        end

        it "filters teachers by TRN" do
          teacher = FactoryBot.create(:teacher, trn: "1234567")
          other_teacher = FactoryBot.create(:teacher, trn: "7654321")

          FactoryBot.create(
            :induction_period,
            teacher: teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )
          FactoryBot.create(
            :induction_period,
            teacher: other_teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          get "/admin/teachers", params: { q: "1234567" }

          expect(response.status).to eq(200)
          expect(response.body).to include("1234567")
          expect(response.body).not_to include("7654321")
        end
      end

      context "with appropriate body filter" do
        it "filters teachers by appropriate body" do
          ab1 = FactoryBot.create(:appropriate_body)
          ab2 = FactoryBot.create(:appropriate_body)
          teacher1 = FactoryBot.create(:teacher)
          teacher2 = FactoryBot.create(:teacher)

          FactoryBot.create(
            :induction_period,
            teacher: teacher1,
            appropriate_body: ab1,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )
          FactoryBot.create(
            :induction_period,
            teacher: teacher2,
            appropriate_body: ab2,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          get "/admin/teachers", params: { appropriate_body_ids: [ab1.id] }

          expect(response.status).to eq(200)
          expect(response.body).to include(teacher1.first_name)
          expect(response.body).not_to include(teacher2.first_name)
        end
      end

      context "with both search and filter" do
        it "combines search and appropriate body filter" do
          ab1 = FactoryBot.create(:appropriate_body)
          ab2 = FactoryBot.create(:appropriate_body)
          teacher1 = FactoryBot.create(:teacher, first_name: "John", last_name: "Smith")
          teacher2 = FactoryBot.create(:teacher, first_name: "John", last_name: "Doe")

          FactoryBot.create(
            :induction_period,
            teacher: teacher1,
            appropriate_body: ab1,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )
          FactoryBot.create(
            :induction_period,
            teacher: teacher2,
            appropriate_body: ab2,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          get "/admin/teachers", params: { q: "John", appropriate_body_ids: [ab1.id] }

          expect(response.status).to eq(200)
          expect(response.body).to include("John Smith")
          expect(response.body).not_to include("John Doe")
        end
      end
    end
  end
end
