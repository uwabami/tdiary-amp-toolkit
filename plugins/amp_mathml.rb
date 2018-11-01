#
# Display amp-mathml
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_mathml, "src" %>
#
add_header_proc do
	mathml_on = false
	case @mode
	when 'latest'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_mathml.+?%>/
			mathml_on = true
		end
	when 'day'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_mathml.+?%>/
			mathml_on = true
		end
	when 'month'
		@diaries.each do |diary|
			if diary[1].to_html =~/<%=amp_mathml.+?%>/
				mathml_on = true
			end
		end
	end
	if mathml_on
		%Q|\n	<script async custom-element="amp-mathml" src="https://cdn.ampproject.org/v0/amp-mathml-0.1.js"></script>|
	end
end

def amp_mathml(src = nil)
	%Q|<amp-mathml layout="container" data-formula="#{src}"></amp-mathml>|
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
9
