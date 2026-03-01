# coding: utf-8
# amp_section_footer2.rb
#
# Copyright (c) 2008 SHIBATA Hiroshi <shibata.hiroshi@gmail.com>
#               2018-2026 Youhei SASAKI <wuabami@gfd-dennou.org>
# You can redistribute it and/or modify it under GPL2.
#

unless respond_to?(:author_mail_tag_amp_section_footer)
  alias :author_mail_tag_amp_section_footer :author_mail_tag
end
def author_mail_tag()
	h = author_mail_tag_amp_section_footer
	h += section_footer_prefetch if check_section_footer_needed
	h
end

unless respond_to?(:robot_control_amp_section_footer)
  alias :robot_control_amp_section_footer :robot_control
end
def robot_control()
	h = robot_control_amp_section_footer
	h += section_footer_async if check_section_footer_needed
	h
end

def section_footer_prefetch
	h = %Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-social-share-0.1.js">|
end
def section_footer_async
	h = %Q|\n\t<script async custom-element="amp-social-share" src="https://cdn.ampproject.org/v0/amp-social-share-0.1.js"></script>|
end
def check_section_footer_needed
	section_footer_on = false
	section_footer_on = true if /^(?:latest|day|month|nyear)$/ =~ @mode
	return section_footer_on
end

def permalink( date, index, escape = true )
	ymd = date.strftime( "%Y%m%d" )
	uri = @conf.index.dup
	uri.sub!( %r|\A(?!https?://)|i, @conf.base_url )
	uri.gsub!( %r|/\.(?=/)|, "" ) # /././ -> /
	link = uri + anchor( "#{ymd}p%02d" % index )
	link.sub!( "#", "%23" ) if escape
	link
end

unless defined?(subtitle)
	def subtitle( date, index, escape = true )
		diary = @diaries[date.strftime( "%Y%m%d" )]
		return "" unless diary
		sn = 1
		diary.each_section do |section|
			if sn == index
				old_apply_plugin = @options["apply_plugin"]
				@options["apply_plugin"] = true
				title = apply_plugin( section.subtitle_to_html, true )
				@options["apply_plugin"] = old_apply_plugin
				title.gsub!( /(?=")/, "\\" ) if escape
				return title
			end
			sn += 1
		end
		''
	end
end

add_section_enter_proc do |date, index|
	@category_to_tag_list = {}
	''
end

alias section_footer2_subtitle_link_original subtitle_link unless defined?( section_footer2_subtitle_link_original )
def subtitle_link( date, index, subtitle )
	s = ''
	@subtitle = subtitle
	if subtitle then
		s = subtitle.sub( /^(?:\[[^\[]+?\])+/ ) do
			$&.scan( /\[(.*?)\]/ ) do |tag|
				@category_to_tag_list[tag.shift] = false # false when diary
			end
			''
		end
	end
	section_footer2_subtitle_link_original( date, index, s.strip )
end

add_section_leave_proc do |date, index|
	unless feed? or bot?
		r = ''
		r += '<nav>'
		r << '<ul>&ensp;</ul>'
		r << '<ul>'
		# add category_tag
		if @category_to_tag_list and not @category_to_tag_list.empty? then
			r << '<li>Tags: </li>'
			@category_to_tag_list.each do |tag, blog|
				r << '<li> ' + category_anchor( "#{tag}" ).sub( /^\[/, '' ).sub( /\]$/, '' ) + '</li>'
			end
		end
		r += %Q[<li>#{add_hatena(date, index, 24)}</li>]
		r += %Q[<li>#{add_twitter(date, index, 24)}</li>]
		r += %Q[<li>#{add_facebook(date, index, 24)}</li>]
		r += %Q[<li>#{add_permalink(date, index, 24)}</li>]
		r << "</ul></nav>"
		r.gsub(/\n+/,'')
	end
end

def add_permalink(date, index, size)
	r  = %Q[<a href="#{permalink(date, index, false)}" class="permalink">]
#	r += %Q[<svg id="SVGRoot" width="#{size}px" height="#{size}px" version="1.1" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="m15.279 8.659c2.8006 2.8036 2.7622 7.2984 0.0169 10.059-5e-3 6e-3 -0.0113 0.0117-0.0169 0.0173l-3.15 3.15c-2.7783 2.7783-7.2984 2.7779-10.076 0-2.7783-2.7778-2.7783-7.2984 0-10.076l1.7393-1.7393c0.46125-0.46125 1.2556-0.15469 1.2794 0.49716 0.0304 0.83071 0.17934 1.6653 0.45422 2.4713 0.0931 0.27291 0.0266 0.57478-0.17733 0.77869l-0.61345 0.61345c-1.3137 1.3137-1.3549 3.4528-0.0541 4.7794 1.3136 1.3396 3.4728 1.3476 4.7965 0.0239l3.15-3.1495c1.3215-1.3214 1.3159-3.4574 0-4.7733-0.17348-0.17315-0.34823-0.30769-0.48473-0.40167a0.75173 0.75173 0 0 1-0.32564-0.59091c-0.0186-0.49532 0.15694-1.0058 0.54834-1.3972l0.98691-0.98696c0.25879-0.25879 0.66478-0.29057 0.96487-0.0811a7.1476 7.1476 0 0 1 0.96197 0.80611zm6.6063-6.6067c-2.7779-2.7779-7.298-2.7783-10.076 0l-3.15 3.15c-6e-3 6e-3 -0.0117 0.0117-0.0169 0.0173-2.7453 2.7606-2.7838 7.2554 0.0169 10.059a7.1463 7.1463 0 0 0 0.96192 0.80606c0.30009 0.20944 0.70613 0.17761 0.96488-0.0811l0.9869-0.98695c0.39141-0.39141 0.56691-0.90183 0.54835-1.3972a0.75173 0.75173 0 0 0-0.32564-0.59091c-0.1365-0.094-0.31125-0.22851-0.48474-0.40167-1.3159-1.3159-1.3214-3.4518 0-4.7733l3.15-3.1495c1.3237-1.3237 3.4828-1.3157 4.7965 0.0239 1.3008 1.3266 1.2596 3.4657-0.0541 4.7794l-0.61346 0.61345c-0.2039 0.20391-0.27042 0.50578-0.17732 0.77869 0.27487 0.80597 0.42384 1.6406 0.45421 2.4713 0.0239 0.65184 0.81816 0.9584 1.2794 0.49715l1.7394-1.7393c2.7783-2.7778 2.7783-7.2984 4e-5 -10.076z" fill="currentColor" stroke-width=".046875"/></svg>]
	r += %Q[</a>]
end

def add_hatena( date, index, size )
	r = %Q[<amp-social-share type="hatena_bookmark" data-share-endpoint="http://b.hatena.ne.jp/entry/#{permalink( date, index )}" width="#{size}" height="#{size}">]
# 	r += %Q[<svg id="SVGRoot" width="#{size}px" height="#{size}px" version="1.1" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"> <g transform="matrix(.08 0 0 .08 .125 .09375)"><path class="fill_3" d="m255.88 0h-211.76c-24.366 0-44.118 19.752-44.118 44.118v211.76c0 24.366 19.752 44.118 44.118 44.118h211.76c24.366 0 44.118-19.752 44.118-44.118v-211.76c0-24.366-19.752-44.118-44.118-44.118z" fill="#00a4de"/><path class="fill_2" d="m0 150v105.88c0 24.366 19.752 44.118 44.118 44.118h211.76c24.366 0 44.118-19.752 44.118-44.118v-105.88z" fill="#008fde"/><path class="fill_1" d="m194.12 83.824h30.883v88.238h-30.883z" fill="#fff"/><path class="fill_1" d="m165.53 154.68c-5.225-5.841-12.492-9.125-21.813-9.833 8.292-2.26 14.313-5.566 18.122-9.983 3.791-4.359 5.672-10.276 5.672-17.723 0-5.895-1.289-11.11-3.785-15.616-2.561-4.479-6.238-8.063-11.074-10.746-4.229-2.327-9.256-3.968-15.116-4.936-5.889-0.938-16.195-1.411-30.984-1.411h-35.96v131.14h37.048c14.884 0 25.617-0.521 32.18-1.518 6.557-1.031 12.059-2.766 16.512-5.145 5.508-2.906 9.709-7.043 12.645-12.357 2.955-5.332 4.418-11.48 4.418-18.51-1e-3 -9.727-2.621-17.543-7.865-23.367zm-61.735-41.174h7.676c8.871 0 14.831 1 17.907 2.994 3.034 2.004 4.583 5.462 4.583 10.389 0 4.74-1.647 8.079-4.905 10.037-3.301 1.921-9.316 2.895-18.123 2.895h-7.138zm30.448 75.205c-3.492 2.145-9.51 3.199-17.954 3.199h-12.492v-28.654h13.032c8.671 0 14.666 1.092 17.854 3.271 3.24 2.18 4.833 6.029 4.833 11.555-1e-3 4.945-1.749 8.496-5.273 10.629z" fill="#fff"/><g fill="#f9f9f9"><path class="fill_4" d="m209.57 180.88c-9.75 0-17.648 7.893-17.648 17.643s7.898 17.65 17.648 17.65c9.738 0 17.643-7.9 17.643-17.65s-7.904-17.643-17.643-17.643z"/><path class="fill_4" d="m159.89 150h-89.302v65.572h37.048c14.884 0 25.617-0.521 32.18-1.518 6.557-1.031 12.059-2.766 16.512-5.145 5.508-2.906 9.709-7.043 12.645-12.357 2.955-5.332 4.418-11.48 4.418-18.51 0-9.725-2.619-17.541-7.863-23.367-1.654-1.839-3.582-3.339-5.638-4.675zm-25.651 38.707c-3.492 2.145-9.51 3.199-17.954 3.199h-12.492v-28.654h13.032c8.671 0 14.666 1.092 17.854 3.271 3.24 2.18 4.833 6.029 4.833 11.555-1e-3 4.945-1.749 8.496-5.273 10.629z"/><path class="fill_4" d="m194.12 150h30.883v22.063h-30.883z"/></g></g></svg>]
	r += %Q[</amp-social-share> ]
	return r
end

def add_facebook(date, index, size)
	r= %Q|<amp-social-share class="amp-social" type="facebook" width="#{size}" height="#{size}" data-param-app_id="174950806745036" data-param-quote="#{subtitle(date, index, false).gsub(/^\* /,'')} - #{@conf.html_title}:"></amp-social-share> |
end

def add_twitter(date, index, size)
	r = %Q|<amp-social-share class="amp-social" type="twitter" width="#{size}" height="#{size}" data-param-text="#{subtitle(date, index, false).gsub(/^\* /,'')} - #{@conf.html_title}:"></amp-social-share> |
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
