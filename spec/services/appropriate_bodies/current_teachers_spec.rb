describe AppropriateBodies::CurrentTeachers do
  let(:appropriate_body) { FactoryBot.create(:appropriate_body) }

  describe "#current" do
    subject { AppropriateBodies::CurrentTeachers.new(appropriate_body) }

    it 'only returns records belonging to the current appropriate body' do
      expect(subject.current.to_sql).to include(%(induction_periods"."appropriate_body_id" = #{appropriate_body.id}))
    end

    it 'only returns ongoing induction periods' do
      expect(subject.current.to_sql).to include(%("induction_periods"."finished_on" IS NULL))
    end
  end
end
