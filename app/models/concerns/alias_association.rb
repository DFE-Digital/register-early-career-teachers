module AliasAssociation
  extend ActiveSupport::Concern

  class_methods do
    def alias_association(alias_name, association_name)
      define_method(alias_name) do
        send(association_name)
      end
    end
  end
end
