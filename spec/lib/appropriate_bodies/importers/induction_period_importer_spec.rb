describe AppropriateBodies::Importers::InductionPeriodImporter do
  let!(:ab_1) { FactoryBot.create(:appropriate_body, legacy_id: '025e61e7-ec32-eb11-a813-000d3a228dfc') }
  let!(:ab_2) { FactoryBot.create(:appropriate_body, legacy_id: '1ddf3e82-c1ae-e311-b8ed-005056822391') }
  let!(:ab_3) { FactoryBot.create(:appropriate_body, legacy_id: 'ef1c5e56-a8e6-41e2-a47d-c75a098cd61f') }
  let!(:ab_4) { FactoryBot.create(:appropriate_body, legacy_id: '67fc4692-2b90-4a80-8131-795eb93bc496') }

  let!(:ect_1) { FactoryBot.create(:teacher, trn: '2600071') }
  let!(:ect_2) { FactoryBot.create(:teacher, trn: '1666461') }
  let!(:ect_3) { FactoryBot.create(:teacher, trn: '2600049') }

  let(:sample_csv_data) do
    <<~CSV
      appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
      #{ab_1.legacy_id},01/01/2012 00:00:00,10/31/2012 00:00:00,Core Induction Programme,3,2600071
      #{ab_2.legacy_id},09/02/2019 00:00:00,11/13/2020 00:00:00,School-based Induction Programme,3,1666461
      #{ab_3.legacy_id},02/01/2012 00:00:00,10/31/2012 00:00:00,Full Induction Programme,3,2600049
      #{ab_4.legacy_id},02/01/2012 00:00:00,10/31/2012 00:00:00,,3,2600049
    CSV
  end

  let(:sample_csv) { CSV.parse(sample_csv_data, headers: true) }
  subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

  it 'converts csv rows to Row objects when initialized' do
    expect(subject.data).to all(be_a(AppropriateBodies::Importers::InductionPeriodImporter::Row))
  end

  it 'converts all rows' do
    expect(subject.data.size).to eql(4)
  end

  describe 'mapping induction programmes' do
    it 'converts names to codes properly' do
      mappings = {
        subject.data.find { |r| r.appropriate_body_id == ab_1.id } => 'cip',
        subject.data.find { |r| r.appropriate_body_id == ab_2.id } => 'diy',
        subject.data.find { |r| r.appropriate_body_id == ab_3.id } => 'fip',
        subject.data.find { |r| r.appropriate_body_id == ab_4.id } => 'fip' # defaults when missing
      }
      mappings.each do |row, expected_induction_programme|
        expect(row.to_hash.fetch(:induction_programme)).to eql(expected_induction_programme)
      end
    end
  end

  describe 'rebuilding periods' do
    context 'when an ECT has one induction period with one AB' do
      let(:sample_csv_data) do
        <<~CSV
          appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
          025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,10/31/2012 00:00:00,,3,2600071
        CSV
      end

      subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

      it 'contains the original row untouched' do
        expect(subject.periods_as_hashes_by_trn).to eql(
          {
            '2600071' => [
              AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                started_on: Date.new(2012, 1, 1),
                finished_on: Date.new(2012, 10, 31),
                induction_programme: nil,
                appropriate_body_id: ab_1.id,
                trn: '2600071',
                number_of_terms: 3
              ).to_hash
            ]
          }
        )
      end
    end

    context 'when an ECT has two induction period with one AB' do
      context 'and the first period ends after the second period has started' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,03/03/2012 00:00:00,Core Induction Programme,3,2600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,02/02/2012 00:00:00,04/04/2012 00:00:00,Full Induction Programme,3,2600071
          CSV
        end

        subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

        it 'combines the two periods so the new period has the earliest start date and the latest finish date' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '2600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 4, 4),
                  induction_programme: 'Core Induction Programme',
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 3
                ).to_hash
              ]
            }
          )
        end
      end

      context 'and the second period ends after the first period has started' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            025e61e7-ec32-eb11-a813-000d3a228dfc,02/02/2012 00:00:00,04/04/2012 00:00:00,,3,2600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,03/03/2012 00:00:00,,3,2600071
          CSV
        end

        subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

        it 'combines the two periods so the new period has the earliest start date and the latest finish date' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '2600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 4, 4),
                  induction_programme: nil,
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 3
                ).to_hash
              ]
            }
          )
        end
      end

      context 'and the first period contains the second' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,04/04/2012 00:00:00,,2,2600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,02/02/2012 00:00:00,03/03/2012 00:00:00,,3,2600071
          CSV
        end

        subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

        it 'only the first is kept' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '2600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 4, 4),
                  induction_programme: nil,
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 2
                ).to_hash
              ]
            }
          )
        end
      end

      context 'and the second period contains the first' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            025e61e7-ec32-eb11-a813-000d3a228dfc,02/02/2012 00:00:00,03/03/2012 00:00:00,Core Induction Programme,1,2600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,01/01/2012 00:00:00,04/04/2012 00:00:00,Full induction programme,4,2600071
          CSV
        end

        subject { AppropriateBodies::Importers::InductionPeriodImporter.new(csv: sample_csv) }

        it 'only the second is kept' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '2600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 4, 4),
                  induction_programme: 'Full Induction Programme',
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 4
                ).to_hash
              ]
            }
          )
        end
      end
    end

    context 'when an ECT has two induction period with one AB' do
      context 'when the periods do not overlap' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            1ddf3e82-c1ae-e311-b8ed-005056822391,01/01/2012 00:00:00,03/03/2012 00:00:00,Core Induction Programme,4,3600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,03/03/2012 00:00:00,05/05/2012 00:00:00,Full Induction Programme,2,3600071
          CSV
        end

        it 'both are kept' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '3600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 3, 3),
                  induction_programme: 'Core Induction Programme',
                  appropriate_body_id: ab_2.id,
                  trn: '2600071',
                  number_of_terms: 4
                ).to_hash,
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 3, 3),
                  finished_on: Date.new(2012, 5, 5),
                  induction_programme: 'Full Induction Prorgramme',
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 2
                ).to_hash
              ]
            }
          )
        end
      end

      context 'when the periods overlap' do
        let(:sample_csv_data) do
          <<~CSV
            appropriate_body_id,started_on,finished_on,induction_programme_choice,number_of_terms,trn
            1ddf3e82-c1ae-e311-b8ed-005056822391,01/01/2012 00:00:00,03/03/2012 00:00:00,Full Induction Programme,1,3600071
            025e61e7-ec32-eb11-a813-000d3a228dfc,02/02/2012 00:00:00,05/05/2012 00:00:00,Core Induction Programme,4,3600071
          CSV
        end

        it 'both are kept but the earlier one is shortened to prevent overlap with the second' do
          expect(subject.periods_as_hashes_by_trn).to eql(
            {
              '3600071' => [
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 1, 1),
                  finished_on: Date.new(2012, 2, 2),
                  induction_programme: 'Full Induction Progamme',
                  appropriate_body_id: ab_2.id,
                  trn: '2600071',
                  number_of_terms: 1
                ).to_hash,
                AppropriateBodies::Importers::InductionPeriodImporter::Row.new(
                  started_on: Date.new(2012, 2, 2),
                  finished_on: Date.new(2012, 5, 5),
                  induction_programme: 'Core Induction Programme',
                  appropriate_body_id: ab_1.id,
                  trn: '2600071',
                  number_of_terms: 4
                ).to_hash
              ]
            }
          )
        end
      end
    end
  end
end
