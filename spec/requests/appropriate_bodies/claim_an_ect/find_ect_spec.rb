RSpec.describe 'Appropriate body claiming an ECT: finding the ECT' do
  include_context 'fake trs api client'

  let(:page_heading) { "Find an early career teacher" }

  describe 'GET /appropriate-body/claim-an-ect/find-ect' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get('/appropriate-body/claim-an-ect/find-ect/new')

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      # FIXME: we don't have appropriate body users yet so this is just making
      #        sure they're logged in
      let!(:user) { sign_in_as(:appropriate_body_user) }

      it 'instantiates a new PendingInductionSubmission and renders the page' do
        allow(PendingInductionSubmission).to receive(:new).and_call_original

        get('/appropriate-body/claim-an-ect/find-ect/new')

        expect(response.body).to include(page_heading)
        expect(PendingInductionSubmission).to have_received(:new).once
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /appropriate-body/claim-an-ect/find-ect' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        post('/appropriate-body/claim-an-ect/find-ect')

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in' do
      before { allow(AppropriateBodies::ClaimAnECT::FindECT).to receive(:new).with(any_args).and_call_original }

      let!(:user) { sign_in_as(:appropriate_body_user) }
      let(:appropriate_body) { AppropriateBody.find(session[:appropriate_body_id]) }
      let(:birth_year_param) { "2001" }
      let(:trn) { "1234567" }

      let(:search_params) do
        {
          trn:,
          "date_of_birth(3)" => "3",
          "date_of_birth(2)" => "5",
          "date_of_birth(1)" => birth_year_param,
        }
      end

      context "when the submission is valid" do
        it 'passes the parameters to the AppropriateBodies::ClaimAnECT::FindECT service and redirects' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(AppropriateBodies::ClaimAnECT::FindECT).to have_received(:new).with(
            appropriate_body:,
            pending_induction_submission: PendingInductionSubmission.last
          )

          expect(response).to be_redirection
          expect(response.redirect_url).to match(%r{/claim-an-ect/check-ect/\d+/edit\z})
        end
      end

      context "when the submission is valid but ECT does not have QTS awarded" do
        include_context 'fake trs api client that finds teacher without QTS'

        it 're-renders the find page and displays the relevant error' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response.redirect_url).to match(%r{/appropriate-body/claim-an-ect/errors/no-qts/\d+\z})
        end
      end

      context "when the submission is valid but ECT was prohibited from teaching" do
        include_context 'fake trs api client that finds teacher prohibited from teaching'

        it 're-renders the find page and displays the relevant error' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response.redirect_url).to match(%r{/appropriate-body/claim-an-ect/errors/prohibited-from-teaching/\d+\z})
        end
      end

      context "when the submission is valid but ECT is exempt" do
        include_context 'fake trs api client that finds teacher with invalid induction status', 'Exempt'

        it 'redirects to exempt error page' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response.redirect_url).to match(%r{/appropriate-body/claim-an-ect/errors/exempt/\d+\z})
        end
      end

      %w[Pass Fail PassedinWales FailedinWales].each do |status|
        context "when the submission is valid but ECT is #{status}" do
          include_context 'fake trs api client that finds teacher with invalid induction status', status

          it 'redirects to completed error page' do
            post(
              '/appropriate-body/claim-an-ect/find-ect',
              params: { pending_induction_submission: search_params }
            )

            expect(response.redirect_url).to match(%r{/appropriate-body/claim-an-ect/errors/completed/\d+\z})
          end
        end
      end

      context "when the submission is valid but ECT has an active induction period with another AB" do
        let(:teacher) { FactoryBot.create(:teacher, trn:) }
        let!(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission, trn: teacher.trn) }
        let!(:induction_period) do
          FactoryBot.create(
            :induction_period,
            appropriate_body: FactoryBot.create(:appropriate_body),
            teacher:,
            started_on: Date.parse("2 October 2022"),
            finished_on: nil
          )
        end

        it 're-renders the find page and displays the relevant error' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response.redirect_url).to match(%r{/appropriate-body/claim-an-ect/errors/induction-with-another-appropriate-body/\d+\z})
        end
      end

      context "when the submission is valid but ECT has an active induction period with the current AB" do
        let(:teacher) { FactoryBot.create(:teacher, trn:) }
        let!(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission, trn: teacher.trn) }
        let!(:induction_period) do
          FactoryBot.create(
            :induction_period,
            :active,
            appropriate_body:,
            teacher:,
            started_on: Date.parse("2 October 2022")
          )
        end

        it 'redirects to the teacher page' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response).to be_redirection
          expect(response.redirect_url).to match(%r{/teachers/\d+\z})
          expect(flash[:notice]).to eq("Teacher #{teacher.corrected_name} already has an active induction period with this appropriate body")
        end
      end

      context "when the submission is valid but no ECT is found" do
        include_context 'fake trs api client that finds nothing'
        let(:birth_year_param) { "2001" }

        it 're-renders the find page and displays the relevant error' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response).to be_ok
          expect(response.body).to include(page_heading)
          expect(response.body).to include(/TRN #{search_params.fetch(:trn)} not found/)
        end
      end

      context "when the submission is invalid" do
        let(:birth_year_param) { (Date.current.year - 2).to_s }

        it 're-renders the find page' do
          post(
            '/appropriate-body/claim-an-ect/find-ect',
            params: { pending_induction_submission: search_params }
          )

          expect(response).to be_ok
          expect(response.body).to include(page_heading)
        end
      end
    end
  end
end
