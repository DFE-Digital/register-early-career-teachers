class LegacyDataImporter
  attr_reader :logger

  def initialize
    @logger = Logger.new(Rails.root.join("log/import-#{Time.zone.now.strftime('%Y%m%d-%H%S')}"))
  end

  def import!
    Migrators::LeadProvider.new(logger).migrate
  end
end
