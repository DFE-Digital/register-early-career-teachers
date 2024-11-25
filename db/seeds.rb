# some sample users/personas to test personas/otp

def print_seed_info(text, indent: 0)
  puts "🌱 " + (" " * indent) + text
end

def describe_mentorship_period(mp)
  print_seed_info("#{mp.mentor.teacher.first_name} #{mp.mentor.teacher.last_name} mentoring #{mp.mentee.teacher.first_name} #{mp.mentee.teacher.last_name} at #{mp.mentor.school.gias_school.name}", indent: 2)
end

print_seed_info("Adding teachers")

emma_thompson = Teacher.create!(first_name: 'Emma', last_name: 'Thompson', trn: '1023456')
kate_winslet = Teacher.create!(first_name: 'Kate', last_name: 'Winslet', trn: '1023457')
alan_rickman = Teacher.create!(first_name: 'Alan', last_name: 'Rickman', trn: '2084589')
hugh_grant = Teacher.create!(first_name: 'Hugh', last_name: 'Grant', trn: '3657894')
harriet_walter = Teacher.create!(first_name: 'Harriet', last_name: 'Walter', trn: '2017654')
hugh_laurie = Teacher.create!(first_name: 'Hugh', last_name: 'Laurie', trn: '4786654')
andre_roussimoff = Teacher.create!(first_name: 'André', last_name: 'Roussimoff', trn: '8886654')
Teacher.create!(first_name: 'Imogen', last_name: 'Stubbs', trn: '6352869')
Teacher.create!(first_name: 'Gemma', last_name: 'Jones', trn: '9578426')

print_seed_info("Adding schools")

school_data = [
  { urn: 3_375_958, name: "Ackley Bridge" },
  { urn: 1_759_427, name: "Abbey Grove School" },
  { urn: 2_472_261, name: "Grange Hill" },
  { urn: 3_583_173, name: "Coal Hill School" },
  { urn: 5_279_293, name: "Malory Towers" },
  { urn: 2_921_596, name: "St Clare's School" },
  { urn: 2_976_163, name: "Brookfield School" },
  { urn: 4_594_193, name: "Crunchem Hall Primary School" },
]

school_data.each do |school_args|
  # FIXME: this is a bit nasty but gets the seeds working again
  GIAS::School.create!(school_args.merge(funding_eligibility: :eligible_for_fip,
                                         induction_eligibility: :eligible,
                                         local_authority_code: rand(20),
                                         establishment_number: school_args[:urn],
                                         type_name: GIAS::Types::ALL_TYPES.sample,
                                         in_england: true,
                                         section_41_approved: false))

  School.create!(school_args.except(:name))
end

ackley_bridge = School.find_by(urn: 3_375_958)
abbey_grove_school = School.find_by(urn: 1_759_427)

print_seed_info("Adding appropriate bodies")

AppropriateBody.create!(name: 'Canvas Teaching School Hub', local_authority_code: 109, establishment_number: 2367, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'South Yorkshire Studio Hub', local_authority_code: 678, establishment_number: 9728, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Ochre Education Partnership', local_authority_code: 238, establishment_number: 6582, dfe_sign_in_organisation_id: SecureRandom.uuid)
umber_teaching_school_hub = AppropriateBody.create!(name: 'Umber Teaching School Hub', local_authority_code: 957, establishment_number: 7361, dfe_sign_in_organisation_id: SecureRandom.uuid)
golden_leaf_academy = AppropriateBody.create!(name: 'Golden Leaf Academy', local_authority_code: 648, establishment_number: 3986, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Frame University London', local_authority_code: 832, establishment_number: 6864, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Easelcroft Academy', local_authority_code: 573, establishment_number: 9273, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Vista College', local_authority_code: 418, establishment_number: 3735, dfe_sign_in_organisation_id: SecureRandom.uuid)

print_seed_info("Adding lead providers")

grove_institute = LeadProvider.create!(name: 'Grove Institute')
LeadProvider.create!(name: 'Evergreen Network')
national_meadows_institute = LeadProvider.create!(name: 'National Meadows Institute')
LeadProvider.create!(name: 'Woodland Education Trust')
LeadProvider.create!(name: 'Teach Orchard')
LeadProvider.create!(name: 'Highland College University')
wildflower_trust = LeadProvider.create!(name: 'Wildflower Trust')
LeadProvider.create!(name: 'Pine Institute')

print_seed_info("Adding delivery partners")

DeliveryPartner.create!(name: 'Rise Teaching School Hub')
DeliveryPartner.create!(name: 'Miller Teaching School Hub')
grain_teaching_school_hub = DeliveryPartner.create!(name: 'Grain Teaching School Hub')
artisan_education_group = DeliveryPartner.create!(name: 'Artisan Education Group')
rising_minds = DeliveryPartner.create!(name: 'Rising Minds Network')
DeliveryPartner.create!(name: 'Proving Potential Teaching School Hub')
DeliveryPartner.create!(name: 'Harvest Academy')

print_seed_info("Adding academic years")

academic_year_2021 = AcademicYear.create!(year: 2021)
academic_year_2022 = AcademicYear.create!(year: 2022)
academic_year_2023 = AcademicYear.create!(year: 2023)
academic_year_2024 = AcademicYear.create!(year: 2024)

print_seed_info("Adding provider partnerships")

grove_artisan_partnership_2021 = ProviderPartnership.create!(
  academic_year: academic_year_2021,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
)

ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
)

grove_artisan_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
)

meadow_grain_partnership_2022 = ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
)

_meadow_grain_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
)

_wildflower_rising_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
)

_wildflower_rising_partnership_2024 = ProviderPartnership.create!(
  academic_year: academic_year_2024,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
)

print_seed_info("Adding teachers:")

print_seed_info("Emma Thompson (mentor)", indent: 2)

emma_thompson_mentoring_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: emma_thompson,
  school: abbey_grove_school,
  started_on: 3.years.ago
)

TrainingPeriod.create!(
  mentor_at_school_period: emma_thompson_mentoring_at_abbey_grove,
  started_on: 3.years.ago,
  finished_on: 140.weeks.ago,
  provider_partnership: grove_artisan_partnership_2021
)

# 10 week break

TrainingPeriod.create!(
  mentor_at_school_period: emma_thompson_mentoring_at_abbey_grove,
  started_on: 130.weeks.ago,
  finished_on: nil,
  provider_partnership: grove_artisan_partnership_2021
)

print_seed_info("Kate Winslet (ECT)", indent: 2)

kate_winslet_ect_at_ackley_bridge = ECTAtSchoolPeriod.create!(
  teacher: kate_winslet,
  school: ackley_bridge,
  started_on: 1.year.ago
)

TrainingPeriod.create!(
  ect_at_school_period: kate_winslet_ect_at_ackley_bridge,
  started_on: 1.year.ago,
  provider_partnership: grove_artisan_partnership_2023
)

InductionPeriod.create!(
  teacher: kate_winslet,
  started_on: 1.year.ago,
  appropriate_body: umber_teaching_school_hub,
  induction_programme: 'fip'
)

print_seed_info("Hugh Laurie (mentor)", indent: 2)

hugh_laurie_mentoring_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: hugh_laurie,
  school: abbey_grove_school,
  started_on: 2.years.ago
)

TrainingPeriod.create!(
  mentor_at_school_period: hugh_laurie_mentoring_at_abbey_grove,
  started_on: 2.years.ago,
  provider_partnership: meadow_grain_partnership_2022
)

print_seed_info("Alan Rickman (ECT)", indent: 2)

alan_rickman_ect_at_ackley_bridge = ECTAtSchoolPeriod.create!(
  teacher: alan_rickman,
  school: ackley_bridge,
  started_on: 2.years.ago
)

TrainingPeriod.create!(
  ect_at_school_period: alan_rickman_ect_at_ackley_bridge,
  started_on: 2.years.ago + 1.month,
  provider_partnership: meadow_grain_partnership_2022
)

InductionPeriod.create!(
  teacher: alan_rickman,
  appropriate_body: golden_leaf_academy,
  started_on: 2.years.ago + 2.months,
  induction_programme: 'fip'
)

print_seed_info("Hugh Grant (ECT)", indent: 2)

hugh_grant_ect_at_abbey_grove = ECTAtSchoolPeriod.create!(
  teacher: hugh_grant,
  school: abbey_grove_school,
  started_on: 2.years.ago
)

TrainingPeriod.create!(
  ect_at_school_period: hugh_grant_ect_at_abbey_grove,
  started_on: 2.years.ago,
  finished_on: 1.week.ago,
  provider_partnership: grove_artisan_partnership_2021
)

InductionPeriod.create!(
  teacher: hugh_grant,
  appropriate_body: golden_leaf_academy,
  started_on: 2.years.ago + 3.days,
  finished_on: 1.week.ago,
  induction_programme: 'fip',
  number_of_terms: 3
)

print_seed_info("Harriet Walter (mentor)", indent: 2)

InductionPeriod.create!(
  appropriate_body: umber_teaching_school_hub,
  teacher: harriet_walter,
  started_on: 2.years.ago,
  finished_on: 1.year.ago,
  induction_programme: 'fip',
  number_of_terms: [1, 2, 3].sample
)

InductionPeriod.create!(
  appropriate_body: golden_leaf_academy,
  teacher: harriet_walter,
  started_on: 1.year.ago,
  induction_programme: 'fip'
)

InductionExtension.create!(
  teacher: harriet_walter,
  number_of_terms: 1.3
)

InductionExtension.create!(
  teacher: harriet_walter,
  number_of_terms: 5
)


print_seed_info("André Roussimoff ('Mentor')", indent: 2)

andre_roussimoff_mentoring_at_ackley_bridge = MentorAtSchoolPeriod.create!(
  teacher: andre_roussimoff,
  school: ackley_bridge,
  started_on: 1.year.ago
)

TrainingPeriod.create!(
  mentor_at_school_period: andre_roussimoff_mentoring_at_ackley_bridge,
  started_on: 1.year.ago,
  provider_partnership: meadow_grain_partnership_2022
)

print_seed_info("Adding mentorships:")

MentorshipPeriod.create!(
  mentor: emma_thompson_mentoring_at_abbey_grove,
  mentee: hugh_grant_ect_at_abbey_grove,
  started_on: 2.years.ago,
  finished_on: 1.year.ago
).tap { |mp| describe_mentorship_period(mp) }

MentorshipPeriod.create!(
  mentor: hugh_laurie_mentoring_at_abbey_grove,
  mentee: hugh_grant_ect_at_abbey_grove,
  started_on: 1.year.ago,
  finished_on: nil
).tap { |mp| describe_mentorship_period(mp) }

MentorshipPeriod.create!(
  mentor: andre_roussimoff_mentoring_at_ackley_bridge,
  mentee: kate_winslet_ect_at_ackley_bridge,
  started_on: 1.year.ago,
  finished_on: nil
).tap { |mp| describe_mentorship_period(mp) }

print_seed_info("Adding persona users")

# The appropriate body names are included in the AB user names as the persona
# login process matches them and sets the session up correctly.
User.create!(name: "Velma Dinkley (#{golden_leaf_academy.name} AB)", email: "velma@example.com")
User.create!(name: "Fred Jones (#{umber_teaching_school_hub.name} AB)", email: "freddy@example.com")

User.create!(name: "Daphne Blake (DfE staff)", email: "daphne@example.com").tap do |daphne_blake|
  DfERole.create!(user: daphne_blake)
end

User.create!(name: "Norville Rogers (DfE staff)", email: "shaggy@example.com").tap do |norville_rogers|
  DfERole.create!(user: norville_rogers)
end
