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
        expect(teacher.first_name).to eq('John')
        expect(teacher.trn).to eq(trn)
      end
    end

    context 'when the API request fails with 404' do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 404, body: 'Not Found') }

      before do
        allow(client.instance_variable_get(:@connection)).to receive(:get).and_return(response)
      end

      it 'returns nil' do
        teacher = client.find_teacher(trn:, date_of_birth:)
        expect(teacher).to be_nil
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
