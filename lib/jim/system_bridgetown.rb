# frozen_string_literal: true

if Module.const_defined?(:Bridgetown)
  module Jim::System
    module_function

    def add_external_file(source_filename, destination_filename)
      relative_destination_filename = destination_filename.relative_path_from(@site.dest)
      static_file = Bridgetown::StaticFile.new(
        @site,
        nil, # @site.source,
        relative_destination_filename.dirname.to_s,
        relative_destination_filename.basename.to_s
      )
      static_file.instance_eval "def path = #{source_filename.to_s.dump}"
      static_file.instance_eval "def modified_time = Time.at(0)"
      static_file.write("")
      @site.static_files.push(static_file)
    end

    Bridgetown.initializer :jim do |_config|
    end
    Bridgetown::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Bridgetown.logger) }
  end
end
