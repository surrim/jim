# frozen_string_literal: true

if Module.const_defined?(:Bridgetown)
  module Jim::System
    module_function

    DEFAULT_TEMPLATE = 'jim_template'

    def add_external_file(source_filename, destination_filename)
      relative_destination_filename = destination_filename.relative_path_from(@site.dest)
      static_file = Bridgetown::StaticFile.new(
        @site,
        nil, # @site.source,
        relative_destination_filename.dirname.to_s,
        relative_destination_filename.basename.to_s
      )
      static_file.instance_eval "def path = #{source_filename.to_s.dump}"
      static_file.instance_eval 'def modified_time = Time.at(0)'
      static_file.write('')
      @site.static_files.push(static_file)
    end

    def read_template_file(template_src)
      Liquid::Template.file_system.read_template_file(template_src || DEFAULT_TEMPLATE)
    end

    Bridgetown.initializer :jim do |config|
      config.source_manifest(origin: Jim, components: File.expand_path('../../components', __dir__))
    end
    Bridgetown::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Bridgetown.logger) }
  end
end
