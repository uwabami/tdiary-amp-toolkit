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
