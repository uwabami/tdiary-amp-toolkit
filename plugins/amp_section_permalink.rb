# -*- coding: utf-8 -*-
# Copyright (C) 2011, KADO Masanori <kdmsnr@gmail.com>
#               2018, Youhei SASAKI <uwabami@gfd-dennou.org>
#
# sample .htaccess:
# <IfModule mod_rewrite.c>
#    RewriteEngine on
#    RewriteRule ^([0-9\-]+)p?([0-9]*)\.html$ ?date=$1&p=$2 [L]
# </IfModule>


def section_mode?
	@mode == 'day' and @cgi.params['p'][0].to_s != ""
end

def short_desc
	case @mode
	when /^(?:latest|day)$/
		diary = @diaries[@date.strftime('%Y%m%d')]
	when 'nyear'
		diary = @diaries[@date.strftime('%Y%m')]
	end
	if section_mode? and diary
		sections = diary.instance_variable_get(:@sections)
		data = sections[@cgi.params['p'][0].to_i - 1]
	elsif diary
		data= diary.instance_variable_get(:@sections)[0]
	end
	if diary
		desc = remove_tag(data.body_to_html.gsub(/\n/,''))
		if desc.length >= 90
			desc = desc[0,87]+"..."
		end
	else
		desc = @conf.description
	end
	desc
end

def ogp_tag
	uri = @conf.index.dup
	uri[0, 0] = base_url if %r|^https?://|i !~ @conf.index
	uri.gsub!( %r|/\./|, '/' )
	image = (@conf.banner.nil? || @conf.banner == '') ? File.join(uri, "#{theme_url}/ogimage.png") : @conf.banner
	h = %Q|<meta property="og:title" content="#{title_tag.gsub(/<[^>]*>/, "")}">|
	ogp = {
		'og:image' => image,
	}
	ogp['og:site_name'] = @conf.html_title
	ogp['og:description'] = short_desc
	case @mode
	when 'day'
		ogp['og:type'] = 'article'
		ogp['article:author'] = @conf.author_name
		ogp['og:url'] = uri + anchor( @date.strftime( '%Y%m%d' ) )
	when 'latest'
		ogp['og:type'] = 'article'
		ogp['article:author'] = @conf.author_name
		ogp['og:url'] = uri + anchor( @date.strftime( '%Y%m%d' ) )
	when 'nyear'
		ogp['og:type'] = 'article'
		ogp['article:author'] = @conf.author_name
		ogp['og:url'] = uri + anchor( @date.strftime( '%Y%m' ) )
	else
		ogp['og:type'] = 'website'
		ogp['og:url'] = uri
	end
	# ogp['twitter:site'] = "@#{@conf['twitter.user']}"
	ogp.map { |k, v|
		h << %Q|\n	<meta property="#{k}" content="#{h(v)}">|
	}
	h
end

## TODO
def description_tag  #-> ld+json
# 	j = %Q|<script type="application/ld+json">\n|
# 	j << <<-JSON
# {
#   "@context": "http://schema.org/",
#   "@type": "NewsArticle",
#   "mainEntityOfPage": {
#     "@type": "WebPage",
#     "@id": "#{@conf.base_url}"
#   },
#   "headline": "#{title_tag.gsub(/<[^>]*>/, "")}",
#   "image": {
#     "@type": "ImageObject",
#     "url": "https://uwabami.junkhub.org/ogimage_640x480.png",
#     "height": 640,
#     "width": 480
#   },
# JSON
# case @mode
# when 'day'
# 	j <<%Q|  "datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
# 	j <<%Q|  "dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
# when 'latest'
# 	j <<%Q|  "datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
# 	j <<%Q|  "dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
# when 'nyear'
# 	j <<%Q|  "datePublished": "#{@diaries[@date.strftime('%Y%m')].date.iso8601}",\n|
# 	j <<%Q|  "dateModified": "#{@diaries[@date.strftime('%Y%m')].last_modified.iso8601}",\n|
# end
# 	j << <<-JSON
#   "author": {
#     "@type": "Person",
#     "name": "#{@conf.author_name}"
#   },
#    "publisher": {
#     "@type": "Organization",
#     "name": "#{@conf.author_name}",
#     "logo": {
#       "@type": "ImageObject",
#       "url": "https://uwabami.junkhub.org/favicon.png",
#       "width":  60,
#       "height": 60
#     }
#   },
#   "description": "#{short_desc}"
# }
# JSON
# 	j << %Q|	</script>|
end

# Change HTML title to section name
alias :_orig_title_tag :title_tag
def title_tag
	if section_mode? and diary = @diaries[@date.strftime('%Y%m%d')]
		sections = diary.instance_variable_get(:@sections)

		title = "<title>"
		section = sections[@cgi.params['p'][0].to_i - 1].stripped_subtitle_to_html
		title << apply_plugin(section, true).chomp
		title << " - #{h @html_title}"
		title << "(#{@date.strftime( '%Y-%m-%d' )})" if @date
		title << "</title>"
		return title
	else
		_orig_title_tag
	end
rescue
	_orig_title_tag
end

# Change permalink <-- ブラウザの移動のために #pNN を末尾に付記するように
def anchor( s )
	if /^([\-\d]+)#?([pct]\d*)?$/ =~ s then
		if $2 then
			s1 = $1
			s2 = $2
			if $2 =~ /^p/
				"#{s1}#{s2}.html\##{s2}"
			else
				"#{s1}.html##{s2}"
			end
		else
			"#$1.html"
		end
	else
		""
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
