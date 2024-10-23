RSpec.describe TRS::APIClient do
  let(:client) { described_class.new }
  let(:trn) { '1234567' }
  let(:date_of_birth) { '1990-01-01' }
  let(:national_insurance_number) { 'QQ123456A' }
  let(:connection) { client.instance_variable_get(:@connection) }

  describe '#find_teacher' do
    let(:response) { instance_double(Faraday::Response, success?: true, body: response_body) }
    let(:expected_path) { "v3/persons/1234567" }

    context 'finding a teacher by TRN and date of birth' do
      let(:response_body) { { 'firstName' => 'John', 'trn' => trn }.to_json }
      let(:expected_payload) { { dateOfBirth: "1990-01-01" } }

      before do
        allow(connection).to receive(:get).with(expected_path, expected_payload).and_return(response)
      end

      it "gets from the persons endpoint with TRN and date of birth" do
        client.find_teacher(trn:, date_of_birth:)

        expect(connection).to have_received(:get).with(expected_path, expected_payload).once
      end

      it 'returns a TRS::Teacher object' do
        teacher = client.find_teacher(trn:, date_of_birth:)

        expect(teacher).to be_a(TRS::Teacher)
        expect(teacher.present.compact).to eq({ trn: "1234567", trs_first_name: "John" })
      end
    end

    context 'finding a teacher by TRN and national insurance number' do
      let(:response_body) { { 'firstName' => 'John', 'trn' => trn }.to_json }
      let(:expected_payload) { { nationalInsuranceNumber: "QQ123456A" } }

      before do
        allow(connection).to receive(:get).with(expected_path, expected_payload).and_return(response)
      end

      it "gets from the persons endpoint with TRN and national insurance number" do
        client.find_teacher(trn:, national_insurance_number:)

        expect(connection).to have_received(:get).with(expected_path, expected_payload).once
      end

      it 'returns a TRS::Teacher object' do
        teacher = client.find_teacher(trn:, national_insurance_number:)

        expect(teacher).to be_a(TRS::Teacher)
        expect(teacher.present.compact).to eq({ trn: "1234567", trs_first_name: "John" })
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
