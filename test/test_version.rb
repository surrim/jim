# frozen_string_literal: true

require_relative 'helper'

class TestVersion < Bridgetown::TestCase
  describe 'Version' do
    before do
      @contents = read('version')
    end

    it 'outputs the Jim version' do
      assert_includes @contents, "Jim version: #{Jim::VERSION}"
    end
  end
end
