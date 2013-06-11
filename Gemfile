# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

source "https://rubygems.org"

ruby "1.9.3"

gem "bundler"

group :test do
  gem "berkshelf",       "~> 1.4.2"
  gem "chef",            "~> 11.2.0"
  gem "foodcritic",      "~> 2.1.0"
  gem "simplecov",       "~> 0.7.1"
  gem "tailor",          "~> 1.2.1"
  gem "thor-foodcritic", "~> 0.2.0"

  # Move to 1.0 version after release.
  gem "test-kitchen", :git => "git://github.com/opscode/test-kitchen.git", :ref => "8ee8d0"

  # Move to 1.2.1 version after release
  gem "chefspec",     :git => "git://github.com/acrmp/chefspec.git", :ref => "13edb34"

  gem "kitchen-vagrant",   "~> 0.9.0"

  # Move to 0.1.1 after release. Using git for region support.
  gem "kitchen-rackspace", :git => "git://github.com/RoboticCheese/kitchen-rackspace.git", :ref => "b55bc0"
end
