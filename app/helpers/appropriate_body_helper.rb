module AppropriateBodyHelper
  InductionProgrammeChoice = Struct.new(:identifier, :name)
  InductionOutcomeChoice = Struct.new(:identifier, :name)

  def induction_programme_choices
    # FIXME: the names here are currently the ones we use internally, they
    #        should be switched with something more appropriate for external
    #        users
    [
      InductionProgrammeChoice.new(identifier: 'cip', name: 'Core induction programme'),
      InductionProgrammeChoice.new(identifier: 'fip', name: 'Full induction programme'),
      InductionProgrammeChoice.new(identifier: 'diy', name: 'Do it yourself')
    ]
  end

  def induction_programme_choice_name(identifier)
    # FIXME: this is a temporary solution until we have real induction programme data
    induction_programme_choices.find { |choice| choice.identifier == identifier }&.name
  end

  def induction_outcome_choices
    [
      InductionProgrammeChoice.new(identifier: 'pass', name: 'Passed'),
      InductionProgrammeChoice.new(identifier: 'fail', name: 'Failed'),
    ]
  end

  def summary_card_for_teacher(teacher)
    induction_start_date = Teachers::InductionPeriod.new(teacher).induction_start_date&.to_fs(:govuk)

    govuk_summary_card(title: Teachers::Name.new(teacher).full_name) do |card|
      card.with_action { govuk_link_to("Show", ab_teacher_path(teacher)) }
      card.with_summary_list(
        actions: false,
        rows: [
          { key: { text: "TRN" }, value: { text: teacher.trn } },
          {
            key: { text: "Induction start date" },
            value: { text: induction_start_date },
          },
          {
            key: { text: "Status" },
            # FIXME: this is a placeholder as we cannot display a real status yet
            value: { text: govuk_tag(text: "placeholder", colour: %w[grey green red purple orange yellow].sample) },
          },
        ]
      )
    end
  end
end
