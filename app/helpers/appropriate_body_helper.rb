module AppropriateBodyHelper
  InductionProgrammeChoice = Struct.new(:identifier, :name)

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
end
