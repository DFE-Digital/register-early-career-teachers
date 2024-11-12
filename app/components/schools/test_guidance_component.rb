module Schools
  class TestGuidanceComponent < ViewComponent::Base
    renders_one :trs_example_teacher_details, "TRSExampleTeacherDetails"

    def render?
      ActiveModel::Type::Boolean.new.cast(ENV.fetch('TEST_GUIDANCE', false))
    end

    class TRSExampleTeacherDetails < ViewComponent::Base
      def head
        ["TRN", "Date of birth"]
      end

      def rows
        [
          %w[3002586 03/02/1977],
          %w[3002585 02/01/1966],
          %w[3002584 24/11/1955],
          %w[3002583 24/09/1977],
          %w[3002582 11/05/1980],
          %w[3002580 04/03/1955],
          %w[3002579 01/08/2001],
          %w[3002578 10/09/1977],
          %w[3002577 02/12/2000],
          %w[3002576 04/03/1999],
        ]
      end

      def call
        safe_join([
          tag.h3('Information to review this journey', class: 'govuk-heading-m'),
          tag.p('To successfully locate an ECT from the TRS API, use credentials from the table below:'),
          govuk_table(head:, rows:)
        ])
      end
    end
  end
end
