RSpec.describe 'Appropriate body recording a failed outcome for a teacher' do
  let!(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:induction_period) do
    FactoryBot.create(
      :induction_period,
      teacher: teacher,
      appropriate_body: appropriate_body,
      started_on: 1.month.ago,
      finished_on: nil,
      induction_programme: 'fip'
    )
  end
  let(:valid_params) do
    {
      pending_induction_submission: {
        finished_on: Date.current,
        number_of_terms: 3,
        outcome: 'fail'
      }
    }
  end

  describe 'GET /appropriate-body/teachers/:teacher_trn/record-failed-outcome/new' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome/new")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      before { sign_in_as(:appropriate_body_user, appropriate_body:) }

      it 'renders the new form for a valid teacher' do
        get("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome/new")

        expect(response).to be_successful
        expect(response.body).to include('Record failed outcome')
      end

      it 'returns not found for an invalid teacher' do
        get("/appropriate-body/teachers/invalid-trn/record-failed-outcome/new")

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /appropriate-body/teachers/:teacher_trn/record-failed-outcome' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        post("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      let!(:user) { sign_in_as(:appropriate_body_user, appropriate_body:) }

      context 'with valid params' do
        let(:fake_record_outcome) { double(AppropriateBodies::RecordOutcome, fail!: true) }

        before do
          allow(AppropriateBodies::RecordOutcome).to receive(:new).and_return(fake_record_outcome)
        end

        it 'creates a new pending induction submission' do
          expect {
            post(
              "/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome",
              params: valid_params
            )
          }.to change(PendingInductionSubmission, :count).by(1)
        end

        it 'calls the record outcome service and redirects' do
          post(
            "/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome",
            params: valid_params
          )

          expect(AppropriateBodies::RecordOutcome).to have_received(:new).with(
            appropriate_body: appropriate_body,
            pending_induction_submission: an_instance_of(PendingInductionSubmission),
            teacher: teacher
          )

          expect(response).to be_redirection
          expect(response.redirect_url).to end_with("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome")
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          {
            pending_induction_submission: {
              finished_on: nil,
              number_of_terms: nil,
              outcome: 'fail'
            }
          }
        end

        it 'renders the new form with errors' do
          post(
            "/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome",
            params: invalid_params
          )

          expect(response).to be_successful
          expect(response.body).to include('Record failed outcome')
        end
      end
    end
  end

  describe 'GET /appropriate-body/teachers/:teacher_trn/record-failed-outcome' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      before { sign_in_as(:appropriate_body_user, appropriate_body:) }

      it 'renders the show page for a valid teacher' do
        get("/appropriate-body/teachers/#{teacher.trn}/record-failed-outcome")

        expect(response).to be_successful
      end
    end
  end
end
