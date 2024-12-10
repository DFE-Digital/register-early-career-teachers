# some sample users/personas to test personas/otp

ECT_COLOUR = :magenta
MENTOR_COLOUR = :yellow

def print_seed_info(text, indent: 0, colour: nil)
  if colour
    puts "🌱 " + (" " * indent) + Colourize.text(text, colour)
  else
    puts "🌱 " + (" " * indent) + text
  end
end

def describe_period_duration(period)
  period.finished_on ? "between #{period.started_on} and #{period.finished_on}" : "since #{period.started_on}"
end

def describe_mentorship_period(mp)
  mentor_name = Colourize.text("#{mp.mentor.teacher.first_name} #{mp.mentor.teacher.last_name}", MENTOR_COLOUR)
  ect_name = Colourize.text("#{mp.mentee.teacher.first_name} #{mp.mentee.teacher.last_name}", ECT_COLOUR)

  print_seed_info("#{mentor_name} mentoring #{ect_name} at #{mp.mentor.school.gias_school.name} #{describe_period_duration(mp)}", indent: 2)
end

def describe_provider_partnership(pp)
  print_seed_info("#{pp.lead_provider.name} (LP) 🤝 #{pp.delivery_partner.name} (DP) in #{pp.academic_year.year}", indent: 2)
end

def describe_lead_provider(lp)
  print_seed_info(lp.name, indent: 2)
end

def describe_delivery_partner(dp)
  print_seed_info(dp.name, indent: 2)
end

def describe_academic_year(ay)
  print_seed_info(ay.year.to_s, indent: 2)
end

def describe_induction_period(ip)
  suffix = "(induction period)"

  print_seed_info("* is having their induction overseen by #{ip.appropriate_body.name} (AB) #{describe_period_duration(ip)} #{suffix}", indent: 4)
end

def describe_training_period(tp)
  pp = tp.provider_partnership
  suffix = "(training period)"

  print_seed_info("* was trained by #{pp.lead_provider.name} (LP) and #{pp.delivery_partner.name} #{describe_period_duration(tp)} #{suffix}", indent: 4)
end

def describe_ect_at_school_period(sp)
  suffix = "(ECT at school period)"

  print_seed_info("* has been an ECT at #{sp.school.name} #{describe_period_duration(sp)} #{suffix}", indent: 4)
end

def describe_mentor_at_school_period(sp)
  suffix = "(mentor at school period)"

  print_seed_info("* was a mentor at #{sp.school.name} from #{sp.started_on} #{describe_period_duration(sp)} #{suffix}", indent: 4)
end

def describe_extension(ext)
  suffix = "(extension)"

  print_seed_info("* had their induction extended by #{ext.number_of_terms} #{suffix}", indent: 4)
end

def describe_pending_induction_submission(pending_induction_submission)
  suffix = "(pending_induction_submission)"

  print_seed_info("* has one pending induction submission from #{pending_induction_submission.appropriate_body.name} #{suffix}", indent: 4)
end

print_seed_info("Adding teachers")

emma_thompson = Teacher.create!(first_name: 'Emma', last_name: 'Thompson', trn: '1023456')
kate_winslet = Teacher.create!(first_name: 'Kate', last_name: 'Winslet', trn: '1023457')
alan_rickman = Teacher.create!(first_name: 'Alan', last_name: 'Rickman', trn: '2084589')
hugh_grant = Teacher.create!(first_name: 'Hugh', last_name: 'Grant', trn: '3657894')
harriet_walter = Teacher.create!(first_name: 'Harriet', last_name: 'Walter', trn: '2017654')
hugh_laurie = Teacher.create!(first_name: 'Hugh', last_name: 'Laurie', trn: '4786654')
andre_roussimoff = Teacher.create!(first_name: 'André', last_name: 'Roussimoff', trn: '8886654')
imogen_stubbs = Teacher.create!(first_name: 'Imogen', last_name: 'Stubbs', trn: '6352869')
gemma_jones = Teacher.create!(first_name: 'Gemma', last_name: 'Jones', trn: '9578426')
anthony_hopkins = Teacher.create!(first_name: 'Anthony', last_name: 'Hopkins', trn: '6228282')

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

schools = school_data.map do |school_args|
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

schools_indexed_by_urn = schools.index_by(&:urn)

ackley_bridge = schools_indexed_by_urn.fetch(3_375_958)
abbey_grove_school = schools_indexed_by_urn.fetch(1_759_427)
mallory_towers = schools_indexed_by_urn.fetch(5_279_293)
brookfield_school = schools_indexed_by_urn.fetch(2_976_163)

print_seed_info("Adding appropriate bodies")

AppropriateBody.create!(name: 'Canvas Teaching School Hub', local_authority_code: 109, establishment_number: 2367, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'South Yorkshire Studio Hub', local_authority_code: 678, establishment_number: 9728, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Ochre Education Partnership', local_authority_code: 238, establishment_number: 6582, dfe_sign_in_organisation_id: SecureRandom.uuid)
umber_teaching_school_hub = AppropriateBody.create!(name: 'Umber Teaching School Hub', local_authority_code: 957, establishment_number: 7361, dfe_sign_in_organisation_id: SecureRandom.uuid)
golden_leaf_teaching_school_hub = AppropriateBody.create!(name: 'Golden Leaf Teaching School Hub', local_authority_code: 648, establishment_number: 3986, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Frame University London', local_authority_code: 832, establishment_number: 6864, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Easelcroft Teaching School Hub', local_authority_code: 573, establishment_number: 9273, dfe_sign_in_organisation_id: SecureRandom.uuid)
AppropriateBody.create!(name: 'Vista College', local_authority_code: 418, establishment_number: 3735, dfe_sign_in_organisation_id: SecureRandom.uuid)

print_seed_info("Adding lead providers")

grove_institute = LeadProvider.create!(name: 'Grove Institute').tap { |dp| describe_lead_provider(dp) }
LeadProvider.create!(name: 'Evergreen Network').tap { |dp| describe_lead_provider(dp) }
national_meadows_institute = LeadProvider.create!(name: 'National Meadows Institute').tap { |dp| describe_lead_provider(dp) }
LeadProvider.create!(name: 'Woodland Education Trust').tap { |dp| describe_lead_provider(dp) }
LeadProvider.create!(name: 'Teach Orchard').tap { |dp| describe_lead_provider(dp) }
LeadProvider.create!(name: 'Highland College University').tap { |dp| describe_lead_provider(dp) }
wildflower_trust = LeadProvider.create!(name: 'Wildflower Trust').tap { |dp| describe_lead_provider(dp) }
LeadProvider.create!(name: 'Pine Institute').tap { |dp| describe_lead_provider(dp) }

print_seed_info("Adding delivery partners")

DeliveryPartner.create!(name: 'Rise Teaching School Hub').tap { |dp| describe_delivery_partner(dp) }
DeliveryPartner.create!(name: 'Miller Teaching School Hub').tap { |dp| describe_delivery_partner(dp) }
grain_teaching_school_hub = DeliveryPartner.create!(name: 'Grain Teaching School Hub').tap { |dp| describe_delivery_partner(dp) }
artisan_education_group = DeliveryPartner.create!(name: 'Artisan Education Group').tap { |dp| describe_delivery_partner(dp) }
rising_minds = DeliveryPartner.create!(name: 'Rising Minds Network').tap { |dp| describe_delivery_partner(dp) }
DeliveryPartner.create!(name: 'Proving Potential Teaching School Hub').tap { |dp| describe_delivery_partner(dp) }
DeliveryPartner.create!(name: 'Harvest Academy').tap { |dp| describe_delivery_partner(dp) }

print_seed_info("Adding academic years")

academic_year_2021 = AcademicYear.create!(year: 2021).tap { |ay| describe_academic_year(ay) }
academic_year_2022 = AcademicYear.create!(year: 2022).tap { |ay| describe_academic_year(ay) }
academic_year_2023 = AcademicYear.create!(year: 2023).tap { |ay| describe_academic_year(ay) }
academic_year_2024 = AcademicYear.create!(year: 2024).tap { |ay| describe_academic_year(ay) }

print_seed_info("Adding provider partnerships")

grove_artisan_partnership_2021 = ProviderPartnership.create!(
  academic_year: academic_year_2021,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
).tap { |pp| describe_provider_partnership(pp) }

ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
).tap { |pp| describe_provider_partnership(pp) }

grove_artisan_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
).tap { |pp| describe_provider_partnership(pp) }

meadow_grain_partnership_2022 = ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
).tap { |pp| describe_provider_partnership(pp) }

_meadow_grain_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
).tap { |pp| describe_provider_partnership(pp) }

_wildflower_rising_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
).tap { |pp| describe_provider_partnership(pp) }

_wildflower_rising_partnership_2024 = ProviderPartnership.create!(
  academic_year: academic_year_2024,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
).tap { |pp| describe_provider_partnership(pp) }

print_seed_info("Adding teachers:")

print_seed_info("Emma Thompson (mentor)", indent: 2, colour: MENTOR_COLOUR)

emma_thompson_mentoring_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: emma_thompson,
  school: abbey_grove_school,
  started_on: 3.years.ago
).tap { |sp| describe_mentor_at_school_period(sp) }

TrainingPeriod.create!(
  mentor_at_school_period: emma_thompson_mentoring_at_abbey_grove,
  started_on: 3.years.ago,
  finished_on: 140.weeks.ago,
  provider_partnership: grove_artisan_partnership_2021
).tap { |tp| describe_training_period(tp) }

# 10 week break

TrainingPeriod.create!(
  mentor_at_school_period: emma_thompson_mentoring_at_abbey_grove,
  started_on: 130.weeks.ago,
  finished_on: nil,
  provider_partnership: grove_artisan_partnership_2021
).tap { |tp| describe_training_period(tp) }

InductionExtension.create!(
  teacher: emma_thompson,
  number_of_terms: 2
).tap { |ext| describe_extension(ext) }

print_seed_info("Kate Winslet (ECT)", indent: 2, colour: ECT_COLOUR)

kate_winslet_ect_at_ackley_bridge = ECTAtSchoolPeriod.create!(
  teacher: kate_winslet,
  school: ackley_bridge,
  started_on: 1.year.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: kate_winslet_ect_at_ackley_bridge,
  started_on: 1.year.ago,
  provider_partnership: grove_artisan_partnership_2023
).tap { |tp| describe_training_period(tp) }

InductionPeriod.create!(
  teacher: kate_winslet,
  started_on: 1.year.ago,
  appropriate_body: umber_teaching_school_hub,
  induction_programme: 'fip'
).tap { |ip| describe_induction_period(ip) }

InductionExtension.create!(
  teacher: kate_winslet,
  number_of_terms: 3
).tap { |ext| describe_extension(ext) }

InductionExtension.create!(
  teacher: kate_winslet,
  number_of_terms: 3
).tap { |ext| describe_extension(ext) }

print_seed_info("Hugh Laurie (mentor)", indent: 2, colour: MENTOR_COLOUR)

hugh_laurie_mentoring_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: hugh_laurie,
  school: abbey_grove_school,
  started_on: 2.years.ago
).tap { |sp| describe_mentor_at_school_period(sp) }

TrainingPeriod.create!(
  mentor_at_school_period: hugh_laurie_mentoring_at_abbey_grove,
  started_on: 2.years.ago,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

InductionExtension.create!(
  teacher: hugh_laurie,
  number_of_terms: 2
).tap { |ext| describe_extension(ext) }

print_seed_info("Alan Rickman (ECT)", indent: 2, colour: ECT_COLOUR)

alan_rickman_ect_at_ackley_bridge = ECTAtSchoolPeriod.create!(
  teacher: alan_rickman,
  school: ackley_bridge,
  started_on: 2.years.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: alan_rickman_ect_at_ackley_bridge,
  started_on: 2.years.ago + 1.month,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

InductionPeriod.create!(
  teacher: alan_rickman,
  appropriate_body: golden_leaf_teaching_school_hub,
  started_on: 2.years.ago + 2.months,
  induction_programme: 'fip'
).tap { |ip| describe_induction_period(ip) }

InductionExtension.create!(
  teacher: alan_rickman,
  number_of_terms: 1.5
).tap { |ext| describe_extension(ext) }

PendingInductionSubmission.create!(
  appropriate_body: golden_leaf_teaching_school_hub,
  trn: alan_rickman.trn,
  date_of_birth: Date.new(1946, 2, 21),
  started_on: 1.month.ago
).tap { |is| describe_pending_induction_submission(is) }

print_seed_info("Hugh Grant (ECT)", indent: 2, colour: ECT_COLOUR)

hugh_grant_ect_at_abbey_grove = ECTAtSchoolPeriod.create!(
  teacher: hugh_grant,
  school: abbey_grove_school,
  started_on: 2.years.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: hugh_grant_ect_at_abbey_grove,
  started_on: 2.years.ago,
  finished_on: 1.week.ago,
  provider_partnership: grove_artisan_partnership_2021
).tap { |tp| describe_training_period(tp) }

InductionPeriod.create!(
  teacher: hugh_grant,
  appropriate_body: golden_leaf_teaching_school_hub,
  started_on: 2.years.ago + 3.days,
  finished_on: 1.week.ago,
  induction_programme: 'fip',
  number_of_terms: 3
).tap { |ip| describe_induction_period(ip) }

InductionExtension.create!(
  teacher: hugh_grant,
  number_of_terms: 1.5
).tap { |ext| describe_extension(ext) }

InductionExtension.create!(
  teacher: hugh_grant,
  number_of_terms: 1
).tap { |ext| describe_extension(ext) }

print_seed_info("Harriet Walter (mentor)", indent: 2, colour: MENTOR_COLOUR)

InductionPeriod.create!(
  appropriate_body: umber_teaching_school_hub,
  teacher: harriet_walter,
  started_on: 2.years.ago,
  finished_on: 1.year.ago,
  induction_programme: 'fip',
  number_of_terms: [1, 2, 3].sample
).tap { |ip| describe_induction_period(ip) }

InductionPeriod.create!(
  appropriate_body: golden_leaf_teaching_school_hub,
  teacher: harriet_walter,
  started_on: 1.year.ago,
  induction_programme: 'fip'
).tap { |ip| describe_induction_period(ip) }

InductionExtension.create!(
  teacher: harriet_walter,
  number_of_terms: 1.3
).tap { |ext| describe_extension(ext) }

InductionExtension.create!(
  teacher: harriet_walter,
  number_of_terms: 5
).tap { |ext| describe_extension(ext) }

print_seed_info("Imogen Stubbs (ECT)", indent: 2, colour: ECT_COLOUR)

InductionPeriod.create!(
  appropriate_body: golden_leaf_teaching_school_hub,
  teacher: imogen_stubbs,
  started_on: 18.months.ago,
  finished_on: 14.months.ago,
  induction_programme: 'fip',
  number_of_terms: 1
).tap { |ip| describe_induction_period(ip) }

InductionPeriod.create!(
  appropriate_body: golden_leaf_teaching_school_hub,
  teacher: imogen_stubbs,
  started_on: 14.months.ago,
  finished_on: nil,
  induction_programme: 'cip'
).tap { |ip| describe_induction_period(ip) }

imogen_stubbs_at_malory_towers = ECTAtSchoolPeriod.create!(
  teacher: imogen_stubbs,
  school: mallory_towers,
  started_on: 2.years.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: imogen_stubbs_at_malory_towers,
  started_on: 1.year.ago,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

InductionExtension.create!(
  teacher: imogen_stubbs,
  number_of_terms: 1
).tap { |ext| describe_extension(ext) }

print_seed_info("Gemma Jones (ECT)", indent: 2, colour: ECT_COLOUR)

InductionPeriod.create!(
  appropriate_body: umber_teaching_school_hub,
  teacher: gemma_jones,
  started_on: 20.months.ago,
  finished_on: nil,
  induction_programme: 'fip'
).tap { |ip| describe_induction_period(ip) }

gemma_jones_at_malory_towers = ECTAtSchoolPeriod.create!(
  teacher: gemma_jones,
  school: mallory_towers,
  started_on: 21.months.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: gemma_jones_at_malory_towers,
  started_on: 20.months.ago,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

InductionExtension.create!(
  teacher: gemma_jones,
  number_of_terms: 1.5
).tap { |ext| describe_extension(ext) }

print_seed_info("André Roussimoff (ECT)", indent: 2, colour: ECT_COLOUR)

andre_roussimoff_mentoring_at_ackley_bridge = MentorAtSchoolPeriod.create!(
  teacher: andre_roussimoff,
  school: ackley_bridge,
  started_on: 1.year.ago
).tap { |sp| describe_mentor_at_school_period(sp) }

TrainingPeriod.create!(
  mentor_at_school_period: andre_roussimoff_mentoring_at_ackley_bridge,
  started_on: 1.year.ago,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

print_seed_info("Anthony Hopkins (ECT)", indent: 2)

anthony_hopkins_ect_at_brookfield_school = ECTAtSchoolPeriod.create!(
  teacher: anthony_hopkins,
  school: brookfield_school,
  started_on: 2.years.ago
).tap { |sp| describe_ect_at_school_period(sp) }

TrainingPeriod.create!(
  ect_at_school_period: anthony_hopkins_ect_at_brookfield_school,
  started_on: 2.years.ago,
  provider_partnership: meadow_grain_partnership_2022
).tap { |tp| describe_training_period(tp) }

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
User.create!(name: "Velma Dinkley (#{golden_leaf_academy.name} Appropriate body)", email: "velma@example.com")
User.create!(name: "Fred Jones (#{umber_teaching_school_hub.name} Appropriate body)", email: "freddy@example.com")

User.create!(name: "Bob Belcher (#{abbey_grove_school.name})", email: "bob@example.com")
User.create!(name: "Serena Moon (#{brookfield_school.name})", email: "serena@example.com")

User.create!(name: "Daphne Blake (DfE staff)", email: "daphne@example.com").tap do |daphne_blake|
  DfERole.create!(user: daphne_blake)
end

User.create!(name: "Norville Rogers (DfE staff)", email: "shaggy@example.com").tap do |norville_rogers|
  DfERole.create!(user: norville_rogers)
end
