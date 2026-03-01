#
# Display amp-mathml
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_mathml "src" %>
#
unless respond_to?(:author_mail_tag_amp_mathml)
  alias :author_mail_tag_amp_mathml :author_mail_tag
end
def author_mail_tag()
	h = author_mail_tag_amp_mathml
	h += mathml_prefetch if check_mathml_needed
	h
end

unless respond_to?(:robot_control_amp_mathml)
  alias :robot_control_amp_mathml :robot_control
end
def robot_control()
	h = robot_control_amp_mathml
	h += mathml_async if check_mathml_needed
	h
end

def mathml_prefetch
	h = %Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-mathml-0.1.js">|
end

def mathml_async
	h = %Q|\n\t<script async custom-element="amp-mathml" src="https://cdn.ampproject.org/v0/amp-mathml-0.1.js"></script>|
end

def check_mathml_needed
	mathml_on = false
	case @mode
	when 'latest'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_mathml\s.+?%>/
			mathml_on = true
		end
	when 'day'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_mathml\s.+?%>/
			mathml_on = true
		end
	when 'month'
		@diaries.each do |diary|
			if diary[1].to_html =~/<%=amp_mathml\s.+?%>/
				mathml_on = true
			end
		end
	when 'nyear'
		@diaries.each do |diary|
			if diary[1].to_html =~/<%=amp_mathml\s.+?%>/
				mathml_on = true
			end
		end
	end
	return mathml_on
end

def amp_mathml(src = nil)
	%Q|<amp-mathml layout="container" data-formula="#{h(src)}"></amp-mathml>|
end

def amp_mathml_inline (src = nil)
	%Q|<amp-mathml layout="container" inline data-formula="#{src}"></amp-mathml>|
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
