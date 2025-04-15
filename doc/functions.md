# Jim Functions

The functions are listed in detail with a regular syntax and a small example.

**Table of Contents**

- [New](#new)
- [Render](#render)
- [Data](#data)
- [Fallback](#fallback)
- [Filename Patterns](#filename-patterns)
- [Format Setups](#format-setups)
- [Formats](#formats)
- [Image Attrs](#image-attris)
- [Image Sizes](#image-sizes)
- [No Markdown](#no-markdown)
- [S10ns](#s10ns)
- [Styles](#styles)
- [Template](#template)
- [Watermark](#watermark)
- [Widths](#widths)

## New

```ruby
def initialize(src, alt = nil, *presets, **kw_preset) # → jim

# liquid
def jim_new(src, alt = nil, *presets) # → jim
```

## Render

```ruby
def render(render = true) # → output

# liquid
def jim_render(jim, render = true) # → output
```

## Data

```ruby
def data(*path, stringify_keys: true) # → data

# liquid
def jim_data(jim, *path) # → data
```

## Fallback

```ruby
def fallback_format(fallback_format = DEFAULT_FALLBACK_FORMAT) # → jim
def fallback_width(fallback_width = DEFAULT_FALLBACK_WIDTH) # → jim
def fallback(fallback_format, fallback_width) # → jim

# liquid
def jim_fallback_format(jim, fallback_format = DEFAULT_FALLBACK_FORMAT) # → jim
def jim_fallback_width(jim, fallback_width = DEFAULT_FALLBACK_WIDTH) # → jim
def jim_fallback(jim, fallback_format, fallback_width) # → jim
```

## Filename Patterns

```ruby
def filename_pattern(filename_pattern) # → jim
def svg_filename_pattern(svg_filename_pattern) # → jim
def filename_patterns(filename_pattern, svg_filename_pattern) # → jim
def reset_filename_pattern # → jim
def reset_svg_filename_pattern # → jim
def reset_filename_patterns # → jim

# liquid
def jim_filename_pattern(jim, filename_pattern) # → jim
def jim_svg_filename_pattern(jim, svg_filename_pattern) # → jim
def jim_filename_patterns(jim, filename_pattern, svg_filename_pattern) # → jim
def jim_reset_filename_pattern(jim) # → jim
def jim_reset_svg_filename_pattern(jim) # → jim
def jim_reset_filename_patterns(jim) # → jim
```

## Format Setups

```ruby
def format_setups(*format_setups, **kw_format_setup) # → jim
def format_setup(format, *setups, **kw_setup) # → jim
def format_setting(format, key, value) # → jim
def merge_format_setups(*format_setups, **kw_format_setup) # → jim
def merge_format_setup(format, *setups, **kw_setup) # → jim
def reset_format_setups # → jim

# liquid
def jim_format_setups(jim, *format_setups) # → jim
def jim_format_setup(jim, format, *setups) # → jim
def jim_format_setting(jim, format, key, value) # → jim
def jim_merge_format_setups(jim, *format_setups) # → jim
def jim_merge_format_setup(jim, format, *setups) # → jim
def jim_reset_format_setups(jim) # → jim
```

## Formats

```ruby
def formats(*formats) # → jim
def append_format(format) # → jim
def append_formats(*formats) # → jim
def prepend_format(format) # → jim
def prepend_formats(*formats) # → jim
def rm_format(format) # → jim
def rm_formats(*formats) # → jim
def rm_all_formats # → jim

# liquid
def jim_formats(jim, *formats) # → jim
def jim_append_format(jim, format) # → jim
def jim_append_formats(jim, *formats) # → jim
def jim_prepend_format(jim, format) # → jim
def jim_prepend_formats(jim, *formats) # → jim
def jim_rm_format(jim, format) # → jim
def jim_rm_formats(jim, *formats) # → jim
def jim_rm_all_formats(jim) # → jim
```

## Image Attrs

```ruby
def img_attrs(*img_attrs, **kw_img_attrs) # → jim
def merge_img_attrs(*img_attrs, **kw_img_attrs) # → jim
def img_attr(key, value) # → jim
def rm_img_attr(key) # → jim
def rm_img_attrs(*keys) # → jim
def rm_all_img_attrs # → jim

# liquid
def jim_img_attrs(jim, *img_attrs) # → jim
def jim_merge_img_attrs(jim, *img_attrs) # → jim
def jim_img_attr(jim, key, value) # → jim
def jim_rm_img_attr(jim, key) # → jim
def jim_rm_img_attrs(jim, *keys) # → jim
def jim_rm_all_img_attrs(jim) # → jim
```

## Image Sizes

```ruby
def img_sizes(*img_sizes, **kw_img_sizes) # → jim
def img_size(media_condition, img_size) # → jim
def rm_img_size(media_condition) # → jim
def rm_img_sizes(*media_conditions) # → jim
def rm_all_img_sizes # → jim

# liquid
def jim_img_sizes(jim, *img_sizes) # → jim
def jim_img_size(jim, media_condition, img_size) # → jim
def jim_rm_img_size(jim, media_condition) # → jim
def jim_rm_img_sizes(jim, *media_conditions) # → jim
def jim_rm_all_img_sizes(jim) # → jim
```

## No Markdown

```ruby
def no_markdown(no_markdown = true) # → jim

# liquid
def jim_no_markdown(jim, no_markdown = true) # → jim
```

## S10ns

```ruby
def s10ns(*s10ns, **kw_s10ns) # → jim
def add_s10n(key, value) # → jim
def add_s10ns(*s10ns, **kw_s10ns) # → jim
def rm_s10n(key) # → jim
def rm_s10ns(*keys) # → jim
def rm_all_s10ns # → jim

# liquid
def jim_s10ns(jim, *s10ns) # → jim
def jim_add_s10n(jim, key, value) # → jim
def jim_add_s10ns(jim, *s10ns) # → jim
def jim_rm_s10n(jim, key) # → jim
def jim_rm_s10ns(jim, *keys) # → jim
def jim_rm_all_s10ns(jim) # → jim
```

## Styles

```ruby
def styles(*styles, **kw_style) # → jim
def style(property, value) # → jim
def rm_style(property) # → jim
def rm_styles(*properties) # → jim
def rm_all_styles # → jim

# liquid
def jim_styles(jim, *styles) # → jim
def jim_style(jim, property, value) # → jim
def jim_rm_style(jim, property) # → jim
def jim_rm_styles(jim, *properties) # → jim
def jim_rm_all_styles(jim) # → jim
```

## Template

```ruby
def template(template) # → jim
def reset_template # → jim

# liquid
def jim_template(jim, template) # → jim
def jim_reset_template(jim) # → jim
```

## Watermark

```ruby
def watermark_src(watermark_src = DEFAULT_WATERMARK_SRC) # → jim
def watermark_size(watermark_size = DEFAULT_WATERMARK_SIZE) # → jim
def watermark_x(watermark_x = DEFAULT_WATERMARK_X) # → jim
def watermark_y(watermark_y = DEFAULT_WATERMARK_Y) # → jim
def watermark_opacity(watermark_opacity = DEFAULT_WATERMARK_OPACITY) # → jim
def watermark(src: UNDEFINED, size: UNDEFINED, x: UNDEFINED, y: UNDEFINED, opacity: UNDEFINED) # → jim
def rm_watermark # → jim

# liquid
def jim_watermark_src(jim, watermark_src) # → jim
def jim_watermark_size(jim, watermark_size) # → jim
def jim_watermark_x(jim, watermark_x) # → jim
def jim_watermark_y(jim, watermark_y) # → jim
def jim_watermark_opacity(jim, watermark_opacity) # → jim
def jim_watermark(jim, src = UNDEFINED, size = UNDEFINED, x = UNDEFINED, y = UNDEFINED, opacity = UNDEFINED) # → jim
def jim_rm_watermark(jim) # → jim
```

## Widths

```ruby
def widths(*widths) # → jim
def add_width(width) # → jim
def add_widths(*widths) # → jim
def rm_width(width) # → jim
def rm_widths(*widths) # → jim
def rm_all_widths # → jim

# liquid
def jim_widths(jim, *widths) # → jim
def jim_add_width(jim, width) # → jim
def jim_add_widths(jim, *widths) # → jim
def jim_rm_width(jim, width) # → jim
def jim_rm_widths(jim, *widths) # → jim
def jim_rm_all_widths(jim) # → jim
```
