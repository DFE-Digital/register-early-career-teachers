class SampleJob < ApplicationJob
  def perform(*args)
    Rails.logger.info "SampleJob#perform with arguments: #{args.inspect}"
  end
end
