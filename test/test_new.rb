# frozen_string_literal: true

require_relative 'helper'

class TestNew < Bridgetown::TestCase
  describe 'New' do
    before do
      @contents = read('new')
    end

    it 'outputs a simple <img>' do
      assert_includes @contents,
                      'Simple: <img type="image/png" src="/images/example-800.png" alt="My awesome image" />'
    end

    it 'outputs a <img> with presets' do
      assert_includes @contents,
                      'With presets: <img type="image/jpeg" src="/images/example-640.jPg" alt="My awesome image" />'
    end

    it 'tests Jim.new src params' do
      assert_equal('.', Jim.new('.').to_h[:src])
    end

    it 'tests invalid Jim.new src params' do
      assert_raises(ArgumentError) { Jim.new }
      assert_raises(ArgumentError) { Jim.new(nil) }
      assert_raises(ArgumentError) { Jim.new('') }
    end
  end
end
