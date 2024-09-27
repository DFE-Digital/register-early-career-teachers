module Migration
  class LeadProvider < Migration::Base
    has_many :partnerships
  end
end
