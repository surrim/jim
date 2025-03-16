# frozen_string_literal: true

module Jim::System
  JIM_DEFAULT_PRESET_PATH_REGEX = /^(config|data)(\.[_[:alpha:]][_[:alnum:]]*)*$/

  module_function

  def info(tag = 'Jim', text) = @logger.info("#{tag}:", text) # rubocop:disable Style/OptionalArguments
  def warn(text) = @logger.warn('Jim:', text)

  def error(text)
    @logger.error('Jim:', text)
    raise(text)
  end

  def config = @site.config
  def path(*src) = Pathname.new('.').join(*src).expand_path(config['root_dir'])
  def source_path(*src) = Pathname.new('.').join(*src).expand_path(config['source'])
  def destination_path(*src) = Pathname.new(@site.in_dest_dir(*src))
  def local_cache_path(*src) = Pathname.new(@site.in_cache_dir('jimcache', *src))
  def cache_path(*src) = config['jim_cache'] ? path(config['jim_cache'], *src) : local_cache_path(*src)
  def default_preset = @default_preset

  def render(template_src, jim_context)
    template = read_template_file(template_src)
    Liquid::Template
      .parse(template, error_mode: :strict)
      .render!(@site.site_payload.merge({ 'jim_context' => jim_context }), {
                 registers: { site: @site },
                 strict_filters: true
               })
  end

  def init(site, logger)
    @site = site
    @logger = logger
    @default_preset = {}
    warn('jim_cache not configured') unless config['jim_cache']
    info("using file://#{File.expand_path(cache_path)}")

    jim_default_preset_path = config['jim_default_preset_path']
    unless jim_default_preset_path
      return info('jim_default_preset_path not used')
    end
    unless jim_default_preset_path.match?(JIM_DEFAULT_PRESET_PATH_REGEX)
      return warn('invalid jim_default_preset_path ignored')
    end

    root, *config_path = jim_default_preset_path.split('.')
    @default_preset = (root == 'data' ? site.data : site.config).dig(*config_path)
  end
end
