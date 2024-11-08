RSpec.describe 'Appropriate body claiming an ECT: checking we have the right ECT' do
  include AuthHelper
  let(:appropriate_body) { AppropriateBody.find(session[:appropriate_body_id]) }
  let(:page_heading) { "Check details for" }
  let!(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }
  let(:pending_induction_submission_id_param) { pending_induction_submission.id.to_s }

  describe 'GET /appropriate-body/claim-an-ect/check-ect/:id/edit' do
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
      let!(:user) { sign_in_as(:appropriate_body_user) }

      it 'finds the right PendingInductionSubmission record and renders the page' do
        allow(PendingInductionSubmission).to receive(:find).with(pending_induction_submission_id_param).and_call_original

        get("/appropriate-body/claim-an-ect/register-ect/#{pending_induction_submission.id}/edit")

        expect(PendingInductionSubmission).to have_received(:find).with(pending_induction_submission_id_param).once
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /appropriate-body/claim-an-ect/check-ect/:id' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        patch("/appropriate-body/claim-an-ect/check-ect/#{pending_induction_submission.id}")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in' do
      let!(:user) { sign_in_as(:appropriate_body_user) }
      before { allow(AppropriateBodies::ClaimAnECT::CheckECT).to receive(:new).with(any_args).and_call_original }

      context "when the submission is valid" do
        let(:confirmation_param) { { confirmed: "1", } }

        before do
          allow_any_instance_of(AppropriateBodies::ClaimAnECT::CheckECT).to receive(:confirm_info_correct).and_call_original
        end

        it 'passes the parameters to the AppropriateBodies::ClaimAnECT::CheckECT service and redirects' do
          patch(
            "/appropriate-body/claim-an-ect/check-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: confirmation_param }
          )

          expect(AppropriateBodies::ClaimAnECT::CheckECT).to have_received(:new).with(
            appropriate_body:,
            pending_induction_submission:
          )

          expect(response).to be_redirection
          expect(response.redirect_url).to match(%r{/claim-an-ect/register-ect/\d+/edit\z})
        end

        it 'calls AppropriateBodies::ClaimAnECT::CheckECT#confirm_info_correct' do
          fake_check_ect = double(AppropriateBodies::ClaimAnECT::CheckECT, confirm_info_correct: pending_induction_submission, pending_induction_submission:)
          allow(AppropriateBodies::ClaimAnECT::CheckECT).to receive(:new).and_return(fake_check_ect)

          patch(
            "/appropriate-body/claim-an-ect/check-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: confirmation_param }
          )

          expect(fake_check_ect).to have_received(:confirm_info_correct).with(true).once
        end
      end

      context "when the submission is invalid" do
        let(:confirmation_param) { { confirmed: "0", } }
        it 'passes the parameters to the AppropriateBodies::ClaimAnECT::CheckECT but does not redirect and rerenders the form' do
          patch(
            "/appropriate-body/claim-an-ect/check-ect/#{pending_induction_submission.id}",
            params: { appropriate_body:, pending_induction_submission: confirmation_param }
          )

          expect(response).to be_ok
          expect(response.body).to include(page_heading)
        end
      end
    end
  end
end
