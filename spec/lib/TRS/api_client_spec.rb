require 'rails_helper'

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
        }.to raise_error(TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found")
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
end
