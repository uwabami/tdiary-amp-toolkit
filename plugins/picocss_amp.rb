# coding: utf-8
# Show navi for picocss theme
#
# Copyright (c) 2023 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.

require 'json'

$debug = false

unless respond_to?(:author_mail_tag_picocss_amp)
  alias :author_mail_tag_picocss_amp :author_mail_tag
end
def author_mail_tag()
	r = author_mail_tag_picocss_amp
	r += %Q|\n\t<!-- ddd amp preload by picocss_amp -->| if $debug
	r += %Q[\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-font-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-form-0.1.js">
	<link rel="preconnect dns-prefetch" href="https://uwabami.junkhub.org/" crossorigin>
	<link rel="preload" as="font" type="font/woff2" href="/assets/fonts/AoyagiKouzanTSubset.woff2" crossorigin>]
	r += %Q|\n\t<!-- /ddd amp preload by picocss_amp -->| if $debug
	r
end
unless respond_to?(:robot_control_picocss_amp)
  alias :robot_control_picocss_amp :robot_control
end
def robot_control
	h = robot_control_picocss_amp
	h += %Q|\n\t<!-- robot contool picocss_amp -->| if $debug
	if @display_mode.include?(@mode) then
		h += %Q|\n\t<script async custom-element="amp-font" src="https://cdn.ampproject.org/v0/amp-font-0.1.js"></script>\n|
		h += %Q|\t<script async custom-element="amp-form" src="https://cdn.ampproject.org/v0/amp-form-0.1.js"></script>\n|
		h += %Q|\t<!-- /robot contool picocss_amp -->| if $debug
	end
	h
end


def google_search
  gsearch = <<"EOS"
<li>
<form method="GET" action="https://www.google.com/cse" target="_top">
<input name="cx" type="hidden" value="017455171263919107349:3ljlf8jzf3m" />
<input name="ie" type="hidden" value="UTF-8" />
<input type="search" placeholder="search" name="q" required>
</form>
</li>
EOS
  gsearch
end

def navi
  navi = ''
  navi += %Q| <div class="wrapper container" id="wholepage">\n|
  navi += %Q| <header>\n|
  navi += %Q|   <nav>\n|
  navi += %Q|     <ul>\n|
  navi += %Q|       <li>\n|
  if @display_names.include?(@mode) then
    navi += %Q|         <a href="#{@conf.index_page}">\n|
    navi += %Q|           <amp-img layout="fixed"\n|
    navi += %Q|                    width="1.2rem"\n|
    navi += %Q|                    height="1.2rem"\n|
    navi += %Q|                    src="#{@conf.base_url}images/top.webp"\n|
    navi += %Q|                    alt="About"\n|
    navi += %Q|                    id="top">\n|
    navi += %Q|             <amp-img fallback\n|
    navi += %Q|                      layout="fixed"\n|
    navi += %Q|                      width="1.2rem"\n|
    navi += %Q|                      height="1.2rem"\n|
    navi += %Q|                      src="#{@conf.base_url}images/top.jpg"\n|
    navi += %Q|                      alt="About"\n|
    navi += %Q|                      id="top">\n|
    navi += %Q|             </amp-img>\n|
    navi += %Q|           </amp-img>\n|
  else
    navi += %Q|         <a href="#{@conf.index_page}">\n|
    navi += %Q|           <img src="#{@conf.base_url}images/top.webp"\n|
    navi += %Q|                alt="About"\n|
    navi += %Q|                id="top"\n|
    navi += %Q|                style="display: inline-block; position: relative; width: 1.2em; height: 1.2em;" />\n|
  end
  navi += %Q|         </a>\n|
  navi += %Q|       </li>\n|
  navi += %Q|     </ul>\n|
  navi += %Q|     <ul>\n|
  navi += %Q|#{google_search}\n|
  navi += %Q|     </ul>\n|
  navi += %Q|  </nav>\n|
  navi += %Q|#{navi_amp} \n|
  navi += %Q| </header> \n|
  navi += %Q| <main role="main">\n|
  navi += %Q|   <div class="content">\n|
  navi += %Q|   <h1 class="title-font">#{@conf.html_title}</h1>\n|
  navi
end

def hide_comment_day_limit
  return false
end

#
# make comment form
#
def comment_description
  begin
    if @conf.options['comment_description'].length > 0 then
      return @conf.options['comment_description']
    end
  rescue
  end
  comment_description_default
end

def comment_form_text
  r = ''
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
