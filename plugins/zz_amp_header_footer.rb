# coding: utf-8
#
# modify header contents for amp html
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
def amp_conf_css   # <-- from amp.rb
	conf_css_path = theme_paths_local.map {|path|
		File.join(File.dirname(path), "conf.css")
	}.find {|path|
		File.exist?(path)
	}
	conf_css_path ? File.read(conf_css_path) : ''
end

def amp_theme_css  # <-- from amp.rb
	_, location, theme = @conf.theme.match(%r|(\w+)/(\w+)|).to_a
	case location
	when 'online'
		require 'uri'
		require 'open-uri'
		uri = URI.parse(theme_url_online(theme))
		uri.scheme ||= 'https'
		URI.parse(uri.to_s).read
	when 'local'
		theme_path = theme_paths_local.map {|path|
			File.join(File.dirname(path), "#{theme}/#{theme}.css")
		}.find {|path|
			File.exist?(path)
		}
		theme_path ? File.read(theme_path) : ''
	end
end

add_header_proc do
	header = ''
	unless /^(?:latest|day|month|nyear|search|categoryview)$/ =~ @mode
		header += %Q|\n	<style amp-custom>\n#{amp_theme_css}#{amp_conf_css}body{padding-top: 100px;}</style>|
	else
		header += %Q|\n	<style amp-custom>#{amp_theme_css.chomp}</style>|
	end
	header += %Q|\n	<style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>|
end

def css_tag
	%Q|<!-- css tag: (re)moved. @see zzz_amp_header_footer.rb -->|
end

def jquery_tag
	%Q|<!-- jquery tag: (re)moved. @see zzz_amp_header_footer.rb -->|
end

def script_tag
	%Q|<!-- script tag: (re)moved. @see zzz_amp_header_footer.rb -->|
end

def jquery_footer_tag
	query = script_tag_query_string
	%Q|	<script src="js/jquery.min.js#{query}" type="text/javascript"></script>|
end

def script_footer_tag
	require 'uri'
	query = script_tag_query_string
	html = @javascripts.keys.sort.map {|script|
		async = @javascripts[script][:async] ? "async" : ""
		if URI(script).scheme or script =~ %r|\A//|
			%Q|	<script src="#{script}" #{async}></script>|
		else
			%Q|	<script src="#{js_url}/#{script}#{query}" #{async}></script>|
		end
	}.join( "\n    " )
	html << "\n" << <<-FOOTER
	<script><!--
	#{@javascript_setting.map{|a| "#{a[0]} = #{a[1]};"}.join("\n\t\t")}
	//-->
	</script>
FOOTER
end

add_footer_proc do
	footer = ""
	if /\A(form|edit|preview|showcomment|conf)\z/ === @mode
		footer += <<-FOOTER
#{jquery_footer_tag.chomp}
#{script_footer_tag.chomp}
FOOTER
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
