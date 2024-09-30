describe Teacher do
  describe "associations" do
    it { is_expected.to have_many(:ect_at_school_periods) }
    it { is_expected.to have_many(:mentor_at_school_periods) }
  end

  describe "validations" do
    subject { FactoryBot.build(:teacher) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:trn).with_message('TRN already exists').case_insensitive }

    describe "trn" do
      context "when the string contains 7 numeric digits" do
        %w[0000001 9999999].each do |value|
          it { is_expected.to allow_value(value).for(:trn) }
        end
      end

      context "when the string contains something other than 7 numeric digits" do
        %w[123456 12345678 ONE4567 123456!].each do |value|
          it { is_expected.not_to allow_value(value).for(:trn) }
        end
      end
    end
  end

  describe 'scopes' do
    describe '#search' do
      it "searches the 'search' column using a tsquery" do
        expect(Teacher.search('Joey').to_sql).to end_with(%{WHERE (teachers.search @@ websearch_to_tsquery('Joey'))})
      end

      describe "matching" do
        let!(:target) { FactoryBot.create(:teacher, first_name: "Malcolm", last_name: "Wilkerson", corrected_name: nil) }
        let!(:other) { FactoryBot.create(:teacher, first_name: "Reese", last_name: "Wilkerson", corrected_name: nil) }

        it "returns only the expected result" do
          results = Teacher.search('Malcolm')

          expect(results).to include(target)
          expect(results).not_to include(other)
        end

        it "supports web search syntax" do
          results = Teacher.search('Wilkerson -Reese')

          expect(results).to include(target)
          expect(results).not_to include(other)
        end
      end
    end
  end
end
