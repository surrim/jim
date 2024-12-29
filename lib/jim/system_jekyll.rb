# frozen_string_literal: true

if Module.const_defined?(:Jekyll)
  module Jim::System
    module_function

    DEFAULT_TEMPLATE = "jim_template.html"

    def add_external_file(source_filename, destination_filename)
      @site_destination_dir ||= destination_path
      Jim::Utils.write_file(destination_filename) do |filename|
        FileUtils.cp(source_filename, filename)
      end
      @site.keep_files.push(destination_filename.relative_path_from(@site_destination_dir).to_s)
    end

    def read_template_file(template_src)
      template_src ||= DEFAULT_TEMPLATE
      include_paths = @site.includes_load_paths + [Pathname.new("#{__dir__}/../../components")]
      include_paths.each do |include_path|
        include_filename = Jekyll::PathManager.join(include_path, template_src)
        return File.read(include_filename) if File.exist?(include_filename)
      end
      raise IOError, "Template file #{template_src} not found"
    end

    Jekyll::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Jekyll.logger) }
  end
end
