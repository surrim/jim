# frozen_string_literal: true

module Jim::System
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
  def cache_path(*src) = config[:jim_cache] ? path(config[:jim_cache], *src) : local_cache_path(*src)

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
    if config[:jim_cache]
      info("using file://#{File.expand_path(config[:jim_cache])}")
    else
      warn('jim_cache not configured')
    end
  end
end
