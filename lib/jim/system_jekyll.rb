# frozen_string_literal: true

if Module.const_defined?(:Jekyll)
  module Jim::System
    module_function

    def add_external_file(source_filename, destination_filename)
      @site_destination_dir ||= destination_path
      Jim::Utils.write_file(destination_filename) do |filename|
        FileUtils.cp(source_filename, filename)
      end
      @site.keep_files.push(destination_filename.relative_path_from(@site_destination_dir).to_s)
    end

    Jekyll::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Jekyll.logger) }
  end
end
