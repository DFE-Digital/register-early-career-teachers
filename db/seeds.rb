# some sample users/personas to test personas/otp
User.create!(name: "Velma Dinkley", email: "velma@example.com")
User.create!(name: "Fred Jones", email: "freddy@example.com")
User.create!(name: "Daphne Blake", email: "daphne@example.com")
User.create!(name: "Norville Rogers", email: "shaggy@example.com")

# Teachers

emma_thompson = Teacher.create!(name: 'Emma Thompson', trn: '1023456')
kate_winslet = Teacher.create!(name: 'Kate Winslet', trn: '1023457')
alan_rickman = Teacher.create!(name: 'Alan Rickman', trn: '2084589')
hugh_grant = Teacher.create!(name: 'Hugh Grant', trn: '3657894')
Teacher.create!(name: 'Harriet Walter', trn: '2017654')
hugh_laurie = Teacher.create!(name: 'Hugh Laurie', trn: '4786654')
Teacher.create!(name: 'Imogen Stubbs', trn: '6352869')
gemma_jones = Teacher.create!(name: 'Gemma Jones', trn: '9578426')

# Schools

ackley_bridge = School.create!(urn: 3_375_958, name: "Ackley Bridge")
School.create!(urn: 2_472_261, name: "Grange Hill")
abbey_grove_school = School.create!(urn: 1_759_427, name: "Abbey Grove School")
School.create!(urn: 3_583_173, name: "Coal Hill School")
School.create!(urn: 5_279_293, name: "Malory Towers")
School.create!(urn: 2_921_596, name: "St Clare's School")
School.create!(urn: 2_976_163, name: "Brookfield School")
School.create!(urn: 4_594_193, name: "Crunchem Hall Primary School")

# Appropriate bodies

AppropriateBody.create!(name: 'Canvas Teaching School Hub', local_authority_code: 109, establishment_number: 2367)
AppropriateBody.create!(name: 'South Yorkshire Studio Hub', local_authority_code: 678, establishment_number: 9728)
AppropriateBody.create!(name: 'Ochre Education Partnership', local_authority_code: 238, establishment_number: 6582)
AppropriateBody.create!(name: 'Umber Teaching School Hub', local_authority_code: 957, establishment_number: 7361)
AppropriateBody.create!(name: 'Golden Leaf Academy', local_authority_code: 648, establishment_number: 3986)
AppropriateBody.create!(name: 'Frame University London', local_authority_code: 832, establishment_number: 6864)
AppropriateBody.create!(name: 'Easelcroft Academy', local_authority_code: 573, establishment_number: 9273)
AppropriateBody.create!(name: 'Vista College', local_authority_code: 418, establishment_number: 3735)

# Lead providers

grove_institute = LeadProvider.create!(name: 'Grove Institute')
LeadProvider.create!(name: 'Evergreen Network')
national_meadows_institute = LeadProvider.create!(name: 'National Meadows Institute')
LeadProvider.create!(name: 'Woodland Education Trust')
teach_orchard = LeadProvider.create!(name: 'Teach Orchard')
LeadProvider.create!(name: 'Highland College University')
wildflower_trust = LeadProvider.create!(name: 'Wildflower Trust')
LeadProvider.create!(name: 'Pine Institute')

# Delivery partners

DeliveryPartner.create!(name: 'Rise Teaching School Hub')
DeliveryPartner.create!(name: 'Miller Teaching School Hub')
grain_teaching_school_hub = DeliveryPartner.create!(name: 'Grain Teaching School Hub')
artisan_education_group = DeliveryPartner.create!(name: 'Artisan Education Group')
rising_minds = DeliveryPartner.create!(name: 'Rising Minds Network')
DeliveryPartner.create!(name: 'Proving Potential Teaching School Hub')
DeliveryPartner.create!(name: 'Harvest Academy')

# Academic years

academic_year_2021 = AcademicYear.create!(year: 2021)
academic_year_2022 = AcademicYear.create!(year: 2022)
academic_year_2023 = AcademicYear.create!(year: 2023)
academic_year_2024 = AcademicYear.create!(year: 2024)

# Provider partnerships

grove_artisan_partnership_2021 = ProviderPartnership.create!(
  academic_year: academic_year_2021,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
)
meadow_grain_partnership_2022 = ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
)
wildflower_rising_partnership_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
)

# Mentor at school period

emma_thompson_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: emma_thompson,
  school: abbey_grove_school,
  started_on: 3.years.ago
)
hugh_laurie_at_abbey_grove = MentorAtSchoolPeriod.create!(
  teacher: hugh_laurie,
  school: abbey_grove_school,
  started_on: 4.years.ago
)
alan_rickman_at_ackley_bridge = MentorAtSchoolPeriod.create!(
  teacher: alan_rickman,
  school: ackley_bridge,
  started_on: 170.days.ago
)

# ECT at school period 

hugh_grant_at_abbey_grove = ECTAtSchoolPeriod.create!(
  teacher: hugh_grant,
  school: abbey_grove_school,
  started_on: 2.years.ago
)
kate_winslet_at_ackley_bridge = ECTAtSchoolPeriod.create!(
  teacher: kate_winslet,
  school: ackley_bridge,
  started_on: 1.year.ago
)

# Training period ...
# ... mentors

TrainingPeriod.create!(
  mentor_at_school_period: emma_thompson_at_abbey_grove,
  started_on: 3.years.ago,
  finished_on: 140.weeks.ago,
  provider_partnership: grove_artisan_partnership_2021
)
TrainingPeriod.create!(
  mentor_at_school_period: hugh_laurie_at_abbey_grove,
  started_on: 4.years.ago,
  provider_partnership: meadow_grain_partnership_2022
)
TrainingPeriod.create!(
  mentor_at_school_period: alan_rickman_at_ackley_bridge,
  started_on: 150.days.ago,
  provider_partnership: meadow_grain_partnership_2022
)

# ... ECTs

TrainingPeriod.create!(
  ect_at_school_period: hugh_grant_at_abbey_grove,
  started_on: 2.years.ago,
  finished_on: 1.day.ago,
  provider_partnership: grove_artisan_partnership_2021
)
TrainingPeriod.create!(
  ect_at_school_period: kate_winslet_at_ackley_bridge,
  started_on: 1.year.ago,
  provider_partnership: grove_artisan_partnership_2021
)

# Mentorship period 

# MentorshipPeriod.create!(
#   ect_at_school_period: hugh_grant_at_abbey_grove,
#   mentor_at_school_period: emma_thompson_at_abbey_grove,
#   started_on: 2.years.ago,
#   finished_on: 1.day.ago
# )