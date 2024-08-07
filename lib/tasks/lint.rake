desc "Lint code repository"
namespace :lint do
  desc "Lint Ruby code"
  task ruby: :environment do
    system "bundle exec rubocop"
  end
  desc "Lint JavaScript code"
  task js: :environment do
    system "npm run lint:js"
  end
  desc "Lint SCSS code"
  task scss: :environment do
    system "npm run lint:scss"
  end
end
