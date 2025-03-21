# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'bridgetown'

Bridgetown.begin!

require File.expand_path('../lib/jim', __dir__)

Bridgetown.logger.log_level = :error

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true)
]

module Bridgetown
  class TestCase < Minitest::Test
    extend Minitest::Spec::DSL

    ROOT_DIR = File.expand_path('fixtures', __dir__)
    SOURCE_DIR = File.join(ROOT_DIR, 'src')
    DEST_DIR = File.expand_path('dest', __dir__)

    def root_dir(*files) = File.join(ROOT_DIR, *files)
    def source_dir(*files) = File.join(SOURCE_DIR, *files)
    def dest_dir(*files) = File.join(DEST_DIR, *files)
    def make_liquid_context(registers = {}) = Liquid::Context.new({}, {}, registers)
    def read(filename) = File.read(dest_dir(filename, 'index.html'))

    def setup
      Bridgetown.reset_configuration!
      @config = Bridgetown.configuration(
        root_dir: root_dir,
        source: source_dir,
        destination: dest_dir,
        quiet: true
      )
      @config.run_initializers! context: :static
      @site = Bridgetown::Site.new(@config)
      @site.process
    end
  end
end
