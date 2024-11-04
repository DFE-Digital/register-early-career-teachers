describe AppropriateBodies::Importers::InductionPeriodImporter do
  let!(:ab_1) { FactoryBot.create(:appropriate_body, legacy_id: '025e61e7-ec32-eb11-a813-000d3a228dfc') }
  let!(:ab_2) { FactoryBot.create(:appropriate_body, legacy_id: '1ddf3e82-c1ae-e311-b8ed-005056822391') }
  let!(:ab_3) { FactoryBot.create(:appropriate_body, legacy_id: '025e61e7-ec32-eb11-a813-000d3a228dfc') }

  let!(:ect_1) { FactoryBot.create(:teacher, trn: '2600071') }
  let!(:ect_2) { FactoryBot.create(:teacher, trn: '1666461') }
  let!(:ect_3) { FactoryBot.create(:teacher, trn: '2600049') }

  let(:sample_csv_data) do
    <<~CSV
      appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
      025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,10/31/2012 00:00:00,,3,2600071
      1ddf3e82-c1ae-e311-b8ed-005056822391,09/02/2019 00:00:00,11/13/2020 00:00:00,,3,1666461
      025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,10/31/2012 00:00:00,,3,2600049
    CSV
  end

  let(:sample_csv) { CSV.parse(sample_csv_data, headers: true) }
  subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

  it 'converts csv rows to Row objects when initialized' do
    expect(subject.data).to all(be_a(AppropriateBodies::Importers::InductionPeriodImporter::Row))
  end

  it 'imports all rows' do
    expect(subject.data.size).to eql(3)
  end
end
