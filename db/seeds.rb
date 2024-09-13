# some sample users/personas to test personas/otp
User.create!(name: "Velma Dinkley", email: "velma@example.com")
User.create!(name: "Fred Jones", email: "freddy@example.com")
User.create!(name: "Daphne Blake", email: "daphne@example.com")
User.create!(name: "Norville Rogers", email: "shaggy@example.com")

Teacher.create!(name: 'Emma Thompson', trn: '1023456')
Teacher.create!(name: 'Kate Winslet', trn: '1023457')
Teacher.create!(name: 'Alan Rickman', trn: '2084589')
Teacher.create!(name: 'Hugh Grant', trn: '3657894')
Teacher.create!(name: 'Harriet Walter', trn: '2017654')

School.create!(urn: 6_789_654, name: "St James'")
School.create!(urn: 6_980_612, name: "St Margarets's")
School.create!(urn: 6_456_897, name: "Anston Brook")
School.create!(urn: 7_765_810, name: "Dinnington School")
School.create!(urn: 4_001_321, name: "Wales School")