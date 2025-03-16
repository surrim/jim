# frozen_string_literal: true

class Jim
  Dir[
    File.join(__dir__.to_s, '*.rb'),
    File.join(__dir__.to_s, 'jim', '*.rb')
  ].each { |file| require_relative file }

  include FallbackMixin
  include FilenamePatternsMixin
  include FormatSetupsMixin
  include FormatsMixin
  include ImgAttrsMixin
  include ImgSizesMixin
  include NewMixin
  include NomarkdownMixin
  include RenderMixin
  include StylesMixin
  include SubstitutionsMixin
  include TemplateMixin
  include WatermarkMixin
  include WidthsMixin

  Liquid::Template.register_filter(LiquidFilters)

  def to_preset
    self.class.preset_keys.map do |preset_key|
      preset_value = instance_variable_get("@#{preset_key}")
      [preset_key, preset_value]
    end.to_h
  end

  def to_h = to_preset.merge(src: @src, alt: @alt)
  def to_s = Jim::Utils.deep_stringify_keys(to_h).to_s
  def to_liquid = self
  def to_json(opts = JSON::PRETTY_STATE_PROTOTYPE) = to_h.to_json(opts)

  class << self
    def hard_coded_preset
      @hard_coded_preset ||= constant_keys.map do |constant_key|
        preset_value = const_get(constant_key)
        preset_key = to_preset_key(constant_key)
        [preset_key, preset_value]
      end.to_h.freeze
    end

    def constant_keys = @constant_keys ||= constants.filter { |constant| constant.start_with?('DEFAULT_') }.freeze
    def preset_keys = @preset_keys ||= constant_keys.map { |constant_key| to_preset_key(constant_key) }.freeze

    private

    def to_preset_key(constant_key) = constant_key['DEFAULT_'.length..].downcase
  end
end
