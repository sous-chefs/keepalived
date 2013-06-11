# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

require "bundler"
require "bundler/setup"
require "thor/foodcritic"
require "berkshelf/thor"
require "kitchen/thor_tasks"

Kitchen::ThorTasks.new

class Tailor < Thor
  require "tailor/cli"

  desc "lint", "Run a lint test against the Cookbook in your current working directory."
  def lint
     ::Tailor::Logger.log = false

    if ::Tailor::CLI.run([]) then
      exit(1)
    end
  end
end
