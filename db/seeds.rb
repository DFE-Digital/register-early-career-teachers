# some sample users/personas to test personas/otp
User.create!(name: "Velma Dinkley", email: "velma@example.com")
User.create!(name: "Fred Jones", email: "freddy@example.com")
User.create!(name: "Daphne Blake", email: "daphne@example.com")
User.create!(name: "Norville Rogers", email: "shaggy@example.com")

emma_thompson = Teacher.create!(name: 'Emma Thompson', trn: '1023456')
Teacher.create!(name: 'Kate Winslet', trn: '1023457')
Teacher.create!(name: 'Alan Rickman', trn: '2084589')
Teacher.create!(name: 'Hugh Grant', trn: '3657894')
Teacher.create!(name: 'Harriet Walter', trn: '2017654')
Teacher.create!(name: 'Hugh Laurie', trn: '4786654')
Teacher.create!(name: 'Imogen Stubbs', trn: '6352869')
Teacher.create!(name: 'Gemma Jones', trn: '9578426')

School.create!(urn: 3_375_958, name: "Ackley Bridge")
School.create!(urn: 2_472_261, name: "Grange Hill")
abbey_grove_school = School.create!(urn: 1_759_427, name: "Abbey Grove School")
School.create!(urn: 3_583_173, name: "Coal Hill School")
School.create!(urn: 5_279_293, name: "Malory Towers")
School.create!(urn: 2_921_596, name: "St Clare's School")
School.create!(urn: 2_976_163, name: "Brookfield School")
School.create!(urn: 4_594_193, name: "Crunchem Hall Primary School")

AppropriateBody.create!(name: 'Canvas Teaching School Hub', local_authority_code: 109, establishment_number: 2367)
AppropriateBody.create!(name: 'South Yorkshire Studio Hub', local_authority_code: 678, establishment_number: 9728)
AppropriateBody.create!(name: 'Ochre Education Partnership', local_authority_code: 238, establishment_number: 6582)
AppropriateBody.create!(name: 'Umber Teaching School Hub', local_authority_code: 957, establishment_number: 7361)
AppropriateBody.create!(name: 'Golden Leaf Academy', local_authority_code: 648, establishment_number: 3986)
AppropriateBody.create!(name: 'Frame University London', local_authority_code: 832, establishment_number: 6864)
AppropriateBody.create!(name: 'Easelcroft Academy', local_authority_code: 573, establishment_number: 9273)
AppropriateBody.create!(name: 'Vista College', local_authority_code: 418, establishment_number: 3735)

grove_institute = LeadProvider.create!(name: 'Grove Institute')
LeadProvider.create!(name: 'Evergreen Network')
national_meadows_institute = LeadProvider.create!(name: 'National Meadows Institute')
LeadProvider.create!(name: 'Woodland Education Trust')
teach_orchard = LeadProvider.create!(name: 'Teach Orchard')
LeadProvider.create!(name: 'Highland College University')
wildflower_trust = LeadProvider.create!(name: 'Wildflower Trust')
LeadProvider.create!(name: 'Pine Institute')

DeliveryPartner.create!(name: 'Rise Teaching School Hub')
DeliveryPartner.create!(name: 'Miller Teaching School Hub')
grain_teaching_school_hub = DeliveryPartner.create!(name: 'Grain Teaching School Hub')
artisan_education_group = DeliveryPartner.create!(name: 'Artisan Education Group')
rising_minds = DeliveryPartner.create!(name: 'Rising Minds Network')
DeliveryPartner.create!(name: 'Proving Potential Teaching School Hub')
DeliveryPartner.create!(name: 'Harvest Academy')

academic_year_2021 = AcademicYear.create!(year: 2021)
academic_year_2022 = AcademicYear.create!(year: 2022)
academic_year_2023 = AcademicYear.create!(year: 2023)
AcademicYear.create!(year: 2024)


grove_artisan_2021 = ProviderPartnership.create!(
  academic_year: academic_year_2021,
  lead_provider: grove_institute,
  delivery_partner: artisan_education_group
)

meadow_grain_2022 = ProviderPartnership.create!(
  academic_year: academic_year_2022,
  lead_provider: national_meadows_institute,
  delivery_partner: grain_teaching_school_hub
)

wildflower_rising_2023 = ProviderPartnership.create!(
  academic_year: academic_year_2023,
  lead_provider: wildflower_trust,
  delivery_partner: rising_minds
)


# Emma Thompson's history
emma_thompson_at_abbey_grove = MentorAtSchoolPeriod.create!(teacher: emma_thompson, school: abbey_grove_school, started_on: 10.years.ago)
TrainingPeriod.create!(mentor_at_school_period: emma_thompson_at_abbey_grove, started_on: 5.years.ago, provider_partnership: grove_artisan_2021)
