# frozen_string_literal: true

require 'chefspec'
require 'chefspec/policyfile'

# Require all our libraries
Dir.glob('libraries/*.rb').shuffle.each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end
