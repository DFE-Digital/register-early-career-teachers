require 'rails_helper'

RSpec.describe 'Appropriate body claiming an ECT: registering the ECT' do
  let!(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let(:page_heading) { "Tell us about" }
  let!(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }
  let(:pending_induction_submission_id_param) { pending_induction_submission.id.to_s }

  describe 'GET /appropriate-body/claim-an-ect/register-ect/:id/edit' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}/edit")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      # FIXME: we don't have appropriate body users yet so this is just making
      #        sure they're logged in
      before { sign_in_as(:appropriate_body_user) }

      it 'finds the right PendingInductionSubmission record and renders the page' do
        allow(PendingInductionSubmission).to receive(:find).with(pending_induction_submission_id_param).and_call_original

        get("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}/edit")

        expect(PendingInductionSubmission).to have_received(:find).with(pending_induction_submission_id_param).once
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /appropriate-body/claim-an-ect/register-ect/:id' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        patch("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in' do
      let!(:user) { sign_in_as(:appropriate_body_user) }
      let(:appropriate_body) { user.appropriate_bodies.first }
      before { allow(AppropriateBodies::ClaimAnECT::CheckECT).to receive(:new).with(any_args).and_call_original }
      before { allow(AppropriateBodies::ClaimAnECT::RegisterECT).to receive(:new).with(any_args).and_call_original }

      context 'when the submission is valid' do
        let(:registration_params) do
          {
            induction_programme: 'fip',
            'started_on(3)' => '4',
            'started_on(2)' => '6',
            'started_on(1)' => '2023'
          }
        end

        before do
          allow_any_instance_of(AppropriateBodies::ClaimAnECT::RegisterECT).to receive(:register).and_call_original
        end

        it 'passes the parameters to the AppropriateBodies::ClaimAnECT::RegisterECT service and redirects' do
          patch(
            "/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: registration_params }
          )

          expect(AppropriateBodies::ClaimAnECT::RegisterECT).to have_received(:new).with(
            appropriate_body:,
            pending_induction_submission:
          )

          expect(response).to be_redirection
          expect(response.redirect_url).to match(%r{/claim-an-ect/register-ect/\d+\z})
        end

        it 'calls AppropriateBodies::ClaimAnECT::RegisterECT#register' do
          fake_register_ect = double(AppropriateBodies::ClaimAnECT::RegisterECT, register: pending_induction_submission)
          allow(AppropriateBodies::ClaimAnECT::RegisterECT).to receive(:new).and_return(fake_register_ect)

          patch(
            "/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: registration_params }
          )

          expect(fake_register_ect).to have_received(:register).with(
            ActionController::Parameters.new(**registration_params).permit!
          ).once
        end
      end

      context "when the submission is invalid" do
        let(:registration_params) { { induction_programme: "xyz", } }
        it 'passes the parameters to the AppropriateBodies::ClaimAnECT::RegisterECT but does not redirect and rerenders the form' do
          patch(
            "/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: registration_params }
          )

          expect(response).to be_ok
          expect(response.body).to include(page_heading)
        end
      end
    end
  end

  describe 'GET /appropriate-body/claim-an-ect/register-ect/:id' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in' do
      before { sign_in_as(:appropriate_body_user) }

      it 'finds the right PendingInductionSubmission record and renders the page' do
        allow(PendingInductionSubmission).to receive(:find).with(pending_induction_submission_id_param).and_call_original

        get("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}/")

        expect(PendingInductionSubmission).to have_received(:find).with(pending_induction_submission_id_param).once
        expect(response).to be_successful
      end
    end
  end
end
