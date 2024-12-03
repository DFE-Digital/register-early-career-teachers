RSpec.describe 'Appropriate body releasing an ECT' do
  let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let(:teacher) { FactoryBot.create(:teacher) }

  describe 'GET /appropriate-body/teachers/:trn/release/new' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/teachers/#{teacher.trn}/release/new")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      let!(:user) { sign_in_as(:appropriate_body_user, appropriate_body:) }

      before do
        InductionPeriod.create!(
          appropriate_body: appropriate_body,
          teacher: teacher,
          started_on: Date.parse("2022-09-01"),
          induction_programme: :fip
        )
      end

      it 'instantiates a new PendingInductionSubmission and renders the page' do
        allow(PendingInductionSubmission).to receive(:new).and_call_original

        get("/appropriate-body/teachers/#{teacher.trn}/release/new")

        expect(response).to be_successful
        expect(PendingInductionSubmission).to have_received(:new).once
      end
    end
  end

  describe 'POST /appropriate-body/teachers/:trn/release' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        post("/appropriate-body/teachers/#{teacher.trn}/release")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      let!(:user) { sign_in_as(:appropriate_body_user, appropriate_body:) }

      before do
        allow(AppropriateBodies::ReleaseECT).to receive(:new).and_call_original
      end

      context "when the teacher has one ongoing induction period" do
        let!(:induction_period) do
          FactoryBot.create(
            :induction_period,
            :active,
            appropriate_body:,
            teacher:,
            started_on: Date.parse("2022-09-01"),
            finished_on: nil,
            number_of_terms: nil
          )
        end

        let(:release_params) do
          {
            pending_induction_submission: {
              finished_on: "2023-07-31",
              number_of_terms: 6
            }
          }
        end

        it 'updates the induction period and redirects to show page' do
          post(
            "/appropriate-body/teachers/#{teacher.trn}/release",
            params: release_params
          )

          induction_period.reload
          expect(induction_period.finished_on).to eq(Date.parse("2023-07-31"))
          expect(induction_period.number_of_terms).to eq(6)

          expect(response).to be_redirection
          expect(response.redirect_url).to match(%r{/appropriate-body/teachers/#{teacher.trn}/release\z})
        end
      end
    end
  end
end
