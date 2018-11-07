# show code snippet via gist.github.com
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_gist gist_id, height %>
#

add_header_proc do
  gist_on = false
  case @mode
  when 'latest'
    if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_gist\s.+?%>/
      gist_on = true
    end
  when 'day'
    if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_gist\s.+?%>/
      gist_on = true
    end
  when 'month'
    @diaries.each do |diary|
      if diary[1].to_html =~/<%=amp_gist\s.+?%>/
        gist_on = true
      end
    end
  when 'nyear'
	@diaries.each do |diary|
	  if diary[1].to_html =~/<%=amp_gist\s.+?%>/
		gist_on = true
	  end
	end
  end
  if gist_on
    %Q|\n	<script async custom-element="amp-gist" src="https://cdn.ampproject.org/v0/amp-gist-0.1.js"></script>|
  end
end

def amp_gist( gist_id, height )
  <<-HTML
<amp-gist data-gistid="#{gist_id}"
    layout="fixed-height"
    height="#{height}">
</amp-gist>
HTML
end
