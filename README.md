<image src="https://raw.githubusercontent.com/surrim/jim/main/jim.webp" alt="Jim" width="400" height="500" style="width: auto; height: 50vh; image-rendering: pixelated; background: purple">

# Jim for Jekyll and Bridgetown

> Superior image processing and responsive HTML5 outputs for Jekyll and Bridgetown, 100% flexible.  
> Using a very efficient and persistent cache, user-defined filenames, templates, watermarks, additional CSS/HTML attributes, SVG forwarding/inlining, raw data and more.

Jim comes with a wide range of features for manipulating images and outputting them in different ways. The workflow follows the [builder pattern](https://refactoring.guru/design-patterns/builder): **Create** an object, **update** necessary attributes, and finally **render** the output.

This is a very simple demonstration which outputs a `<picture>` tag, with `srcset` attributes and everything else:

***Liquid syntax (for [Jekyll](https://jekyllrb.com/) and [Bridgetown](https://www.bridgetownrb.com/))***

```liquid
{{ "_images/example.png" | jim_new: "My amazing picture"
  | jim_formats: "avif", "webp"
  | jim_widths: 960, 1440, 1920
  | jim_filename_pattern: "%{dirname}/%{basename}-%{width}.%{extension}"
  | jim_render
}}
```

***ERB syntax (only for Bridgetown)***

```erb
<%== Jim.new('_images/example.png', 'My amazing picture')
  .formats('avif', 'webp')
  .widths(960, 1440, 1920)
  .filename_pattern('%{dirname}/%{basename}-%{width}.%{extension}')
  .render
%>
```

It's worth to mention that you can use [presets](#presets) to avoid explicit configuration.

You can even write own templates, include watermarks, and there's inherent SVG support - see [doc/functions.md](doc/functions.md) for details.

I'm already using this plugin for some websites. So don't assume you've found a dead project - it's just new!

**Table of Contents**

- [Prerequisites](#prerequisites)
- [Comparison with Related Projects](#comparison-with-related-projects)
- [Quick Installation](#quick-installation)
- [Jim Basics](#jim-basics)
- [Presets](#presets)
- [Caching](#caching)
- [Frequently Asked Questions](#frequently-asked-questions)

## Prerequisites

Jim requires [ImageMagick](https://imagemagick.org/) and [blake3-rb](https://github.com/Shopify/blake3-rb) with their native dependencies installed on your system.

- **ImageMagick** (required by the `rmagick` gem)

  ```bash
  # Debian / Ubuntu
  sudo apt install libmagickwand-dev

  # Fedora
  sudo dnf install ImageMagick-devel

  # macOS
  brew install imagemagick
  ```

- **Rust toolchain** (required by the `blake3-rb` gem to compile native extensions)

  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

  See [rustup.rs](https://rustup.rs/) for details.

## Comparison with Related Projects

|                                    | Jekyll ImageMagick ([GH](https://github.com/surrim/jim), [GL](https://gitlab.com/surrim/jim)) | [Jekyll Picture Tag](https://github.com/rbuchberger/jekyll_picture_tag) | [jekyll-responsive-image](https://github.com/wildlyinaccurate/jekyll-responsive-image) | [Jekyll Resize](https://github.com/MichaelCurrin/jekyll-resize)      |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **Author**                         | [surrim](https://spirit.surrim.org/)                                                          | [rbuchberger](https://robert-buchberger.com/)                           | [wildlyinaccurate](https://wildlyinaccurate.com/)                                      | [MichaelCurrin](https://michaelcurrin.github.io/)                    |
| **Last release**                   |                                                                                               | [Jun 2025](https://github.com/rbuchberger/jekyll_picture_tag/releases/) | [Jan 2018](https://github.com/wildlyinaccurate/jekyll-responsive-image/releases/)      | [Nov 2021](https://github.com/MichaelCurrin/jekyll-resize/releases/) |
| **License**                        | GPLv3                                                                                         | BSD-3-Clause license                                                    | MIT                                                                                    | MIT                                                                  |
| **Engine**                         | rmagick & inkscape                                                                            | vips or ImageMagick                                                     | rmagick                                                                                | mini_magick                                                          |
| **File name patterns**             | ✅ flexible                                                                                    | ❌ hard-coded                                                            | ☑️ flexible, one pattern for all                                                       | ❌ hard-coded                                                         |
| **Watermarks**                     | ✅ flexible                                                                                    | ❌ no                                                                    | ❌ no                                                                                   | ❌ no                                                                 |
| **Own templates**                  | ✅ yes                                                                                         | ❌ no                                                                    | ❌ no                                                                                   | ❌ no                                                                 |
| **SVG handling**                   | ✅ flexible                                                                                    | ❌ no                                                                    | ❌ no                                                                                   | ❌ no                                                                 |
| **Cropping**                       | ❌ no                                                                                          | ✅ yes                                                                   | ❌ no                                                                                   | ❌ no                                                                 |
| **Additional HTML/CSS attributes** | ✅ yes                                                                                         | ✅ yes                                                                   | ❌ no                                                                                   | ❌ no                                                                 |
| **Auto-rotate**                    | ✅ yes                                                                                         | ❌ no                                                                    | ☑️ optional                                                                            | ❌ no                                                                 |
| **Strip EXIF data**                | ✅ yes                                                                                         | ☑️ optional                                                             | ☑️ optional                                                                            | ❓ unknown                                                            |
| **Cache**                          | ✅ temporary or persistent, multilevel                                                         | ✅ temporary                                                             | ☑️ optional                                                                            | ❌ no                                                                 |
| **Hash function**                  | BLAKE3                                                                                        | MD5                                                                     | -                                                                                      | SHA256                                                               |

## Quick Installation

- Add the following line to your `Gemfile`
  
  ```ruby
  gem 'jim',
    :git => 'https://github.com/surrim/jim.git',
    :branch => 'main'
  ```

- Run `bundle update`

- _Jekyll only_: Enable Jim in your Jekyll `_config.yml` file
  
  ```yaml
  plugins:
    # [...]
    - jim
  ```

- _Bridgetown only_: Initialize Jim with your Bridgetown `config/initializers.rb` file
  
  ```ruby
  Bridgetown.configure do |config|
    # [...]
    init :jim
  end
  ```

Now you are ready to use all [functions](doc/functions.md) in your project 🏁

## Jim Basics

To avoid confusion, some important notes first

- There are almost no hard-coded configuration queries
- 🅙 means Jekyll only, 🅑 means Bridgetown only
- The term _structure_ refers to any associative array which can be read from a [data file](https://jekyllrb.com/docs/datafiles/), the [front matter](https://jekyllrb.com/docs/front-matter/) or a custom [site configuration](https://jekyllrb.com/docs/configuration/) variable and can be stored as [liquid variable](https://shopify.github.io/liquid/tags/variable/) for further processing. When using Bridgetown you can even use [ERB / Ruby Code](https://www.bridgetownrb.com/docs/template-engines/erb-and-beyond)
- Images are always auto-rotated by `EXIF orientation` and stripped of metadata
- Liquid and ERB template examples are used for the documentation

There are three special functions:

- `jim_new` / `Jim.new`
- `jim_render` / `render`
- `jim_data` / `data`

All other functions modify attributes and [return the Jim object again](https://en.wikipedia.org/wiki/Method_chaining).

In general, the first step is to create a Jim object with `jim_new` / `Jim.new`. It contains information for the image transformations like wanted image formats, dimensions, watermark settings, but also data for the rendering process like additional CSS and the `sizes` attribute. It can be passed to other tags and finally to `jim_render` / `render`.

The `jim_render` / `render` function starts the image processing and outputs a `<img>`, `<picture>` or `<svg>` tag by default. It can even use a custom template or output the raw data for a template.

***Simple `<img>` picture with `src` and `alt` attributes***

```liquid
{{ "_images/example.png" | jim_new: "My awesome image" | jim_render }}
```

```erb
<%== Jim.new('_images/example.png', 'My awesome image').render %>
```

***Advanced `<picture>` tag with `srcset` and `sizes` attributes, done with chained Liquid filters / ruby methods***

```liquid
{{ "_images/example.png" | jim_new: "My awesome image"
  | jim_formats: "avif", "webp"
  | jim_widths: 960, 1440, 1920
  | jim_append_img_size: "min-width: 576px", "540px"
  | jim_append_img_size: nil, "100vw"
  | jim_render
}}
```

```erb
<%== Jim.new('_images/example.png', 'My awesome image')
  .formats('avif', 'webp')
  .widths(960, 1440, 1920)
  .append_img_size('min-width: 576px', '540px')
  .append_img_size(nil, '100vw')
  .render
%>
```

***Conditional loading="lazy" attribute***

```liquid
{%- assign jim = "_images/example.png" | jim_new: "My awesome image" %}
{%- if site.use_lazyloading %}
{%-   assign jim = jim | jim_img_attr: "loading", "lazy" %}
{%- endif %}
{{ jim | jim_render }}
```

```erb
<% jim = Jim.new('_images/example.png', 'My awesome image') %>
<% if site.use_lazyloading %>
<%   jim.img_attr('loading', 'lazy') %>
<% end %>
<%== jim.render %>
```

As you can see there are many ways to use Jim.

## Presets

There are three types of presets:

1. The minimal hard-coded preset
2. One optional project-wide preset
3. Additional presets from any structure for `jim_new` / `Jim.new`

### Minimal hard-coded preset

To find out Jim's hard-coded preset, use the following commands and ignore the `src` and `alt` settings:

```liquid
{{ "." | jim_new: nil | jim_data }}
```

```erb
<%== Jim.new('.').data %>
```

The following JSON block contains the stripped hard-coded preset.

```yaml
filename_pattern: "%{dirname}/%{basename}-%{width}.%{extension}"
svg_filename_pattern: "%{dirname}/%{basename}.svgz"
format_setups:
  ! '':
    quality: 75
  image/bmp:
    background: white
  image/jpeg:
    background: white
    extension: jpg
  image/tiff:
    background: white
s10ns:
  jim_version: "0.3.0"
```

### Project-wide preset

If you want to set a project-wide Jim preset you can add `jim_default_preset_path` to your 🅙 `_config.yml` or 🅑 `bridgetown.config.yml` file:

```yaml
jim_default_preset_path: config.my_jim_defaults

my_jim_defaults: # example
  filename_pattern: "%{dirname}/%{basename}-%{width}.%{extension}"
  svg_filename_pattern: "%{dirname}/%{basename}.svgz"

# Or use data files:
# jim_default_preset_path: data.jim.my_defaults
# ... and put your configuration into _data/jim/my_defaults.yml  
```

### Additional presets from any structure

If you want to change some values, just overwrite them. For instance create `_data/my_jim_setup.yml`:

```yaml
formats:
  - avif
  - webp
widths:
  - 960
  - 1280
  - 1600
  - 1920
watermark_src: asserts/_branding.png
watermark_x: 0 # left
watermark_y: 1 # bottom
```

Then you can use it this way:

```liquid
{{ "_images/example.png"
  | jim_new: "My amazing picture", site.data.my_jim_setup
  | jim_render
}}
```

```erb
<%== Jim.new('_images/example.png', 'My amazing picture', site.data.my_jim_setup)
  .render
%>
```

ℹ️ It's always possible to print out the Jim object data with `jim_data` / `data` and copy relevant parts to a preset file.  
Sometimes it's useful to use inheritance by using many presets. You can even use [YAML anchors and aliases](https://written.dev/yaml/syntax-anchors-aliases) to avoid duplication.

## Caching

The Jim cache is a core component and always used.

Briefly, the cache file names are derived from the [BLAKE3](https://github.com/BLAKE3-team/BLAKE3/blob/master/README.md) hash and the exact image transformations. This makes it possible to read metadata very quickly and copy images directly from the cache without any further processing.

To properly set the cache path, please update your 🅙 `_config.yml` or 🅑 `bridgetown.config.yml` file:

```yaml
jim_cache: ~/.jimcache
```

- There are no corrupt files; unfinished write operations lead to `.tmp` files

- Each time a cached file is used, its modification time (`mtime`) will be updated. This way, old data can be found and deleted without any problems.
  
  Using Linux you could use the following commands to delete old files:
  
  ```bash
  find ~/.jimcache -type f -mmin +45 -delete # older than 45min
  find ~/.jimcache -type f -name "*.tmp" -delete # unfinished files
  ```

- It's safe to copy or share the cache folder with other systems

The BLAKE3 hashes of the images are also cached by filename, size, and modification time with nanosecond resolution. This "blake3 cache" is stored in the local Jekyll or Bridgetown cache folder because filenames and modification times depend on the host machine. The second-level cache ensures that hashing is insanely fast - even with several thousand high-resolution TIFF files.

## Frequently Asked Questions

### Which image types are supported?

Basically everything depends on ImageMagick.

> ImageMagick supports reading over 100 major file formats (not including sub-formats).

See [supported image formats](https://imagemagick.org/script/formats.php#supported).

There are no artificial restrictions. So it's not limited to `jpg`, `png`, `webp`, `avif`, `heic`, `ico`, etc. You can even use `pdf` or `psd` files as input... or output `xbm` files. But please use your brain to avoid `pdf` files in `<img>` tags and similar things 🙏

### What about cropping images?

I just haven't implemented it yet, because I had no use of it.

There are still some open questions that should be kept in mind. I wrote them down as user stories:

- Alice as a designer wants to use a _different source images_ for small devices to attract more people

- Bob as a blogger only wants to use _cropped original images_ for small devices to make his life easier

- Christine as a perfectionist wants to do the same like Bob, but for some images she has alternative pictures like Alice, so she has a perfect solution for everything

- David as a gallery developer wants to crop a landscape image in a 1:1 ratio and _specify the "center"_ to create thumbnails

### Why not vips? It's faster than ImageMagick!

Yes, indeed, [vips](https://github.com/libvips/ruby-vips/blob/master/README.md#benchmarks) is quite fast. My first attempt was to use it.  
Unfortunately, the quality and image size suffer. I didn't want to convert the images to AVIF and forget about the file size at the same time.  
However, the highly efficient cache avoids unnecessary conversions. Only the first pass takes a long time.

### Who is Jim?

A bishop from another world. He can perform some unusual magic and is damn fast.
