RSpec.describe TRS::APIClient do
  let(:client) { described_class.new }
  let(:trn) { '1234567' }
  let(:date_of_birth) { '1990-01-01' }

  describe '#find_teacher' do
    context 'when the API request is successful' do
      let(:response_body) { { 'firstName' => 'John', 'trn' => trn }.to_json }
      let(:response) { instance_double(Faraday::Response, success?: true, body: response_body) }

      before do
        allow(client.instance_variable_get(:@connection)).to receive(:get).and_return(response)
      end

      it 'returns a TRS::Teacher object' do
        teacher = client.find_teacher(trn:, date_of_birth:)
        expect(teacher).to be_a(TRS::Teacher)
        expect(teacher.present).to eq(
          {
            date_of_birth: nil,
            trn: "1234567",
            trs_alerts: nil,
            trs_email_address: nil,
            trs_first_name: "John",
            trs_induction_start_date: nil,
            trs_induction_status: nil,
            trs_induction_status_description: nil,
            trs_initial_teacher_training_end_date: nil,
            trs_initial_teacher_training_provider_name: nil,
            trs_last_name: nil,
            trs_qts_awarded: nil,
            trs_qts_status_description: nil,
          }
        )
      end
    end

    context 'when the API request fails with 404' do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 404, body: 'Not Found') }

      before do
        allow(client.instance_variable_get(:@connection)).to receive(:get).and_return(response)
      end

      it 'raises TRS::Errors::TeacherNotFound' do
        expect {
          client.find_teacher(trn:, date_of_birth:)
        }.to raise_error(
          TRS::Errors::TeacherNotFound,
          "No teacher with the provided teacher reference number and date of birth was found"
        )
      end
    end

    context 'when the API request fails with other errors' do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: 'Internal Server Error') }

      before do
        allow(client.instance_variable_get(:@connection)).to receive(:get).and_return(response)
      end

      it 'raises an error' do
        expect { client.find_teacher(trn:, date_of_birth:) }.to raise_error("API request failed: 500 Internal Server Error")
      end
    end
  end

  # FIXME: update this after we implement the API queries
  describe '#begin_induction!' do
    context "calls logger" do
      it "logs the call" do
        expect(Rails.logger).to receive(:info).with("TRS API: begin_induction(#{trn}, 2021-09-01)")
        client.begin_induction!(trn:, start_date: '2021-09-01')
      end
    end
  end

  describe '#complete_induction!' do
    context "calls logger" do
      it "logs the call" do
        expect(Rails.logger).to receive(:info).with("TRS API: complete_induction(#{trn}, 2021-09-01, completed)")
        client.complete_induction!(trn:, completion_date: '2021-09-01', status: 'completed')
      end
    end
  end
end
