class Teachers::FullNameParser
  attr_reader :full_name

  def initialize(full_name:)
    @full_name = full_name
  end

  def first_name
    parsed_name.first
  end

  def last_name
    parsed_name.last
  end

  def parsed_name
    @parsed_name ||= parse_full_name
  end

private

  # TODO: there is more we could do to sanitize/compose the name if necessary
  #       such as fix bad hyphenation eg "Smithers -Jones" or handle suffix titles eg "Esq."
  def parse_full_name
    n1 = full_name.strip
    n1 = n1.gsub(/\(.*\)/, "")
    n1 = n1.gsub(/\A((mrs|miss|mr|ms|dr|)\.?)/i, "")
    n1 = n1.strip
    n1.split(/\s/)
  end
end
