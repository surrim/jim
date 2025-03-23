---
layout: default
preset:
  fallback_width: 640
---

<%
  src = '_images/example.png'
  alt = 'My awesome image'
%>

Simple: <%== Jim.new(src, alt).render %>

With presets: <%== Jim.new(src, alt, page.data.preset, site.data.jim_preset, format_setups: { jpg: { extension: 'jPg' }}).render %>
