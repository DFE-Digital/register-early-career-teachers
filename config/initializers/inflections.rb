# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "API"  # Application Programming Interface
  inflect.acronym "DfE"  # Department for Education
  inflect.acronym "ECT"  # Early Career Teacher
  inflect.acronym "GIAS" # Get Information About Schools
  inflect.acronym "OTP"  # One-time Password
  inflect.acronym "TRN"  # Teacher Reference Number
  inflect.acronym "TRS"  # Teaching Record System
  inflect.acronym "ITT"  # Initial teacher training
end
