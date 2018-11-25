# coding: utf-8
#
# modify header contents for amp html
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
def doctype
	%Q[<!doctype html>]
end

def author_mail_tag
	%Q|<!-- author mail tag -->|
end

def robot_control
	if /^form|edit|preview|showcomment$/ =~ @mode then
		%Q|<meta name="robots" content="noindex,nofollow">|
	else
		%Q|<!-- robot control tag -->|
	end
end
def ogp_tag
	# title
	h = %Q|<meta property="og:type" content="article">|
	ogp = {}
	# image
	image = (@conf.banner.nil? || @conf.banner == '') ? File.join(@conf.base_url, "#{theme_url}/ogimage.png") : @conf.banner
	ogp['og:image'] = image
	# options
	ogp['article:author'] = @conf.author_name
	ogp['og:site_name'] = @conf.html_title
	ogp['og:description'] = short_desc
	case @mode
	when 'day'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))
	when 'latest'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "") + "(最新)"
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))
	when 'nyear'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@cgi.params['date'][0].to_s))
	when 'month'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@date.strftime('%Y%m')))
	else
#		ogp['og:type'] = 'website'
#		ogp['og:url'] = uri
	end
	if @conf['twitter.user']
		ogp['twitter:card'] = 'summary'
		ogp['twitter:site'] = "@#{@conf['twitter.user']}"
		ogp['twitter:url' ] = ogp['og:url']
		ogp['twitter:title'] = ogp['og:title']
		ogp['twitter:description'] = ogp['og:description']
		ogp['twitter:image'] = ogp['og:image']
	end
	ogp.map { |k, v|
		h << %Q|\n	<meta property="#{k}" content="#{h(v)}">|
	}
	h += <<-LD_JSON_HEAD
\n\t<script type="application/ld+json">
	{
		"@context": "http://schema.org",
		"@type": "BlogPosting",
			"mainEntityOfPage":{
				"@type":"WebPage",
				"@id":"#{@conf.base_url}"
			},
			"headline": "#{ogp['og:title']}",
			"image": {
				"@type": "ImageObject",
				"url": ""https://uwabami.junkhub.org/ogimage_640x480.png"
				"height": 480,
				"width": 640
			},
LD_JSON_HEAD
	case @mode
	when 'day'
		h <<%Q|			"datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
		h <<%Q|			"dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
	when 'latest'
		h <<%Q|			"datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
		h <<%Q|			"dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
	# when 'month'
	# 	h <<%Q|			"datePublished": "#{@diaries[@date.strftime('%Y%m')]}",\n|
	# 	h <<%Q|			"dateModified": "#{@diaries[@date.strftime('%Y%m')]}",\n|
	# when 'nyear'
	# 	h <<%Q|			"datePublished": "#{@diaries[@cgi.params['date'][0].to_s]}",\n|
	# 	h <<%Q|			"dateModified": "#{@diaries[@cgi.params['date'][0].to_s]}",\n|
	end
	h += <<-LD_JSON_BOTTOM.chomp
			"author": {
				"@type": "Person",
				"name": "#{ogp['article:author']}",
				"image": "https://uwabami.junkhub.org/log/images/face.jpg"
			},
			"publisher": {
				"@type": "Organization",
				"name": "#{ogp['article:author']}",
				"logo": {
					"@type": "ImageObject",
					"url": "#{ogp['og:image']}",
					"height": 240,
					"width": 320
				}
			},
		"description": "#{ogp['og:description']}"
	}
	</script>
LD_JSON_BOTTOM
end

add_header_proc do
	header = "	<!-- #{@mode} -->\n"
	case @mode
	when 'latest'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'day'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'month'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m')))}">|
	when 'nyear'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@cgi.params['date'][0].to_s))}">|
	else
		''
	end
	header
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
