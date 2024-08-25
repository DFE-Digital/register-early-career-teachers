module EnvironmentHelper
  def environment_specific_header_colour_class(environment: Rails.env)
    return if environment.in?(%w[test production])

    "app-header--#{environment}"
  end

  def environment_specific_phase_banner(environment: Rails.env)
    kwargs = case environment
             when "development"
               {
                 tag: { text: "Development", colour: environment_colour(environment) },
                 text: "The application is running in development mode"
               }
             when "review"
               {
                 tag: { text: "Review", colour: environment_colour(environment) },
                 text: "This is a review application, not a real service",
               }
             when "staging"
               {
                 tag: { text: "Staging", colour: environment_colour(environment) },
                 text: "This is a staging environment",
               }
             when "sandbox"
               {
                 tag: { text: "Sandbox", colour: environment_colour(environment) },
                 text: "This is a sandbox environment",
               }
             when "test", "production"
               {
                 tag: { text: "Beta" },
                 text: govuk_link_to("Give feedback about this service", "#"),
               }
             end

    govuk_phase_banner(**kwargs)
  end

private

  # NOTE: these should match the colours set in colour-overrides.scss
  def environment_colour(environment)
    {
      "development" => "pink",
      "review" => "orange",
      "test" => "red",
      "staging" => "purple",
      "sandbox" => "yellow"
    }.fetch(environment)
  end
end
