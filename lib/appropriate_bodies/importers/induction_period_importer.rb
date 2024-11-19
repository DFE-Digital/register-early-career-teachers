require 'csv'

module AppropriateBodies::Importers
  class InductionPeriodImporter
    LOGFILE = Rails.root.join("log/induction_period_import.log").freeze

    attr_accessor :csv, :data

    Row = Struct.new(:appropriate_body_id, :started_on, :finished_on, :induction_programme, :number_of_terms, :trn, keyword_init: true) do
      def range
        started_on...finished_on
      end

      def to_hash
        { appropriate_body_id:, started_on:, finished_on:, number_of_terms:, induction_programme: convert_induction_programme }
      end

      def length
        (finished_on || Time.zone.today) - started_on
      end

    private

      def convert_induction_programme
        {
          "Full Induction Programme" => "fip",
          "Core Induction Programme" => "cip",
          "School-based Induction Programme" => "diy" # FIXME: check this! - perhaps school-funded fip?
        }.fetch(induction_programme, "fip")
      end
    end

    def initialize(filename: Rails.root.join('db/samples/appropriate-body-portal/induction-periods.csv'), csv: nil)
      File.delete(LOGFILE) if File.exist?(LOGFILE)

      @csv = csv || CSV.read(filename, headers: true)

      data = @csv.map do |row|
        logger.debug("attempting to import row: #{row.to_hash}")

        unless (appropriate_body_id = appropriate_bodies[row['appropriate_body_id']])
          logger.warn("No AB found for ID #{row['appropriate_body_id']}")

          next
        end

        Row.new(
          appropriate_body_id:,
          started_on: extract_date(row['started_on']),
          finished_on: extract_date(row['finished_on']),
          induction_programme: row['induction_programme_choice'],
          number_of_terms: row['number_of_terms'].to_i,
          trn: row['trn']
        )
      end

      @data = data.compact
    end

    def import
      count = 0

      periods_by_trn.each do |trn, rows|
        logger.debug("adding rows for #{trn}")
        teacher_id = teachers[trn]

        InductionPeriod.transaction do
          rows.map do |row|
            InductionPeriod.create!(**row, teacher_id:)
            count += 1
          end
        end
      end

      [count, @csv.count]
    end

    def periods_by_trn
      @data
        .reject { |ip| ip.finished_on && ip.started_on >= ip.finished_on } # FIXME: log these
        .group_by(&:trn)
        .transform_values { |periods| periods.sort_by { |p| [p.started_on, p.length, p.appropriate_body_id] } }
        .each_with_object({}) do |(trn, rows), h|
          keep = []

          rows.each do |current|
            keep << current and next if keep.empty?
            keep << current and next if keep.none? { |sibling| current.range.overlap?(sibling.range) }

            keep
              .select { |sibling| sibling.range.overlap?(current.range) }
              .each do |sibling|
                if sibling.appropriate_body_id == current.appropriate_body_id
                  case
                  when sibling.range.cover?(current.range)
                    #                  ┌─────────────────────────────┐
                    #   Current        │           DISCARD           │
                    #                  └─────────────────────────────┘
                    #               ┌──────────────────────────────────────┐
                    #   Sibling     │                KEEP                  │
                    #               └──────────────────────────────────────┘
                    next
                  when current.range.cover?(sibling.range)
                    #               ┌──────────────────────────────────────┐
                    #   Current     │               KEEP                   │
                    #               └──────────────────────────────────────┘
                    #                  ┌─────────────────────────────┐
                    #   Sibling        │           DISCARD           │
                    #                  └─────────────────────────────┘
                    keep.delete(sibling)
                    keep << current
                  when sibling.range.cover?(current.started_on) && !sibling.range.cover?(current.finished_on)
                    #                     ┌───────────────────────────────────────┐
                    #   Current           │              DISCARD                  │
                    #                     └───────────────────────────────────────┘
                    #                                                           ▼
                    #               ┌─────────────────────────────────────────┬───┐
                    #   Sibling     │                EXTEND                   │╳╳╳│
                    #               └─────────────────────────────────────────┴───┘
                    sibling.finished_on = current.finished_on
                  when !sibling.range.cover?(current.started_on) && sibling.range.cover(current.finished_on)
                    #               ┌──────────────────────────────────────┐
                    #   Current     │              DISCARD                 │
                    #               └──────────────────────────────────────┘
                    #                  ▼
                    #               ┌─────┬──────────────────────────────────────┐
                    #   Sibling     │╳╳╳╳╳│             EXTEND                   │
                    #               └─────┴──────────────────────────────────────┘
                    sibling.started_on = current.started_on
                  else
                    fail
                  end
                else
                  case
                  when sibling.range.cover?(current.range) || current.range.cover?(sibling.range)
                    # an indunction period from one AB entirely contains one from another,
                    # which do we keep?
                    #
                    # This might never happen in prod so let's ignore it for now
                    # FIXME: log these
                    logger.error("periods contained by other period detected")
                  when sibling.range.cover?(current.started_on) && !sibling.range.cover?(current.finished_on)
                    #                         ┌─────────────────────────────────┐
                    #   Current               │          KEEP                   │
                    #                         └─────────────────────────────────┘
                    #
                    #               ┌─────────┬┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┐
                    #   Sibling     │ SHRINK  │                    ┊
                    #               └─────────┴┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┘
                    sibling.finished_on = current.started_on
                    keep << current
                  end
                end
              end
          end

          h[trn] = keep
        end
    end

    def periods_as_hashes_by_trn
      periods_by_trn.transform_values { |v| v.map(&:to_hash) }
    end

  private

    def logger
      @logger ||= Logger.new(LOGFILE).tap do |l|
        l.level = Logger::Severity::DEBUG
      end
    end

    def appropriate_bodies
      @appropriate_bodies ||= AppropriateBody
        .select(:id, :legacy_id)
        .each_with_object({}) { |t, h| h[t.legacy_id] = t.id }
    end

    def teachers
      @teachers ||= Teacher
        .select(:id, :trn)
        .each_with_object({}) { |t, h| h[t.trn] = t.id }
    end

    def extract_date(datetime)
      return if datetime.blank?

      date = datetime.first(10)

      Date.strptime(date, '%m/%d/%Y')
    end
  end
end
