RSpec.describe TRS::APIClient do
  let(:client) { described_class.new }
  let(:trn) { '1234567' }
  let(:date_of_birth) { '1990-01-01' }
  let(:connection) { client.instance_variable_get(:@connection) }

  describe '#find_teacher' do
    context 'when the API request is successful' do
      let(:response_body) { { 'firstName' => 'John', 'trn' => trn }.to_json }
      let(:response) { instance_double(Faraday::Response, success?: true, body: response_body) }

      before do
        allow(connection).to receive(:get).and_return(response)
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
        allow(connection).to receive(:get).and_return(response)
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
        allow(connection).to receive(:get).and_return(response)
      end

      it 'raises an error' do
        expect { client.find_teacher(trn:, date_of_birth:) }.to raise_error("API request failed: 500 Internal Server Error")
      end
    end
  end

  describe '#begin_induction!' do
    let(:response) { instance_double(Faraday::Response, success?: true) }
    let(:trn) { '0000123' }
    let(:start_date) { '2024-01-01' }
    let(:expected_payload) { { 'inductionStatus' => 'InProgress', 'startDate' => start_date }.to_json }

    before do
      allow(connection).to receive(:put).with("v3/persons/#{trn}/induction", expected_payload).and_return(response)
    end

    it "puts to the induction endpoint with the 'begin' parameters" do
      client.begin_induction!(trn:, start_date:)

      expect(connection).to have_received(:put).with("v3/persons/#{trn}/induction", expected_payload).once
    end
  end

  describe '#pass_induction!' do
    let(:response) { instance_double(Faraday::Response, success?: true) }
    let(:trn) { '0000234' }
    let(:completion_date) { '2024-02-02' }
    let(:expected_payload) { { 'inductionStatus' => 'Pass', 'completionDate' => completion_date }.to_json }

    before do
      allow(connection).to receive(:put).with("v3/persons/#{trn}/induction", expected_payload).and_return(response)
    end

    it "puts to the induction endpoint with the 'pass' parameters" do
      client.pass_induction!(trn:, completion_date:)

      expect(connection).to have_received(:put).with("v3/persons/#{trn}/induction", expected_payload).once
    end
  end

  describe '#fail_induction!' do
    let(:response) { instance_double(Faraday::Response, success?: true) }
    let(:trn) { '0000345' }
    let(:completion_date) { '2024-03-03' }
    let(:expected_payload) { { 'inductionStatus' => 'Fail', 'completionDate' => completion_date }.to_json }

    before do
      allow(connection).to receive(:put).with("v3/persons/#{trn}/induction", expected_payload).and_return(response)
    end

    it "puts to the induction endpoint with the 'fail' parameters" do
      client.fail_induction!(trn:, completion_date:)

      expect(connection).to have_received(:put).with("v3/persons/#{trn}/induction", expected_payload).once
    end
  end
end
