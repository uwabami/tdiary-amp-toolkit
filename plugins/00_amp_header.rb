# coding: utf-8
#
# modify header contents for amp html
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
#  TODO: ld+json should be added

def doctype
	%Q[<!doctype html>]
end

def author_mail_tag
	%Q|<!-- author mail tag -->|
end

def css_tag
	%Q|<!-- css tag: (re)moved. @see zzz_amp_header.rb -->|
end

def description_tag
	if @conf.description and not(@conf.description.empty?) then
		%Q[<meta name="description" content="#{h @conf.description}">]
	else
		''
	end
	%Q|<!-- description tag -->|
end

def jquery_tag
	%Q|<!-- jquery tag: (re)moved. @see zzz_amp_header.rb -->|
end

def script_tag
	%Q|<!-- script tag: (re)moved. @see zzz_amp_header.rb -->|
end

def robot_control
	if /^form|edit|preview|showcomment$/ =~ @mode then
		%Q|<meta name="robots" content="noindex,nofollow">|
	else
		%Q|<!-- robot control tag -->|
	end
end

def amp_canonical_url(diary)
	URI.join(@conf.base_url, anchor(diary.date.strftime('%Y%m%d')))
end

## TODO
def amp_ld_json
	j =''
	j << <<-JSON
JSON
end

add_header_proc do
	header = ''
	case @mode
	when 'latest'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'day'
		diary = @diaries[@date.strftime('%Y%m%d')]
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'month'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m')))}">|
	else
		''
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
