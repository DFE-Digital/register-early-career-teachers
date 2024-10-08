module Migration
  class User < Migration::Base
    has_one :teacher_profile

    def self.with_trn(trn)
      joins(:teacher_profile).where(teacher_profile: { trn: }).first
    end
  end
end
