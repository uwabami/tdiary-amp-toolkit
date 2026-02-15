# embed iframe
#
# usage:
#   amp_iframe(src, width, height)
#

add_header_proc do
  iframe_on = false
  case @mode
  when 'latest'
    if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_iframe\s.+?%>/
      iframe_on = true
    end
  when 'day'
    if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_iframe\s.+?%>/
      iframe_on = true
    end
  when 'month'
    @diaries.each do |diary|
      if diary[1].to_html =~/<%=amp_iframe\s.+?%>/
        iframe_on = true
      end
    end
  end
  if iframe_on
    %Q|\n	<script async custom-element="amp-iframe" src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>|
  end
end

def amp_iframe(src = nil, width = nil, ratio = nil)
  width ||= 100
  ratio ||= 1
  <<-HTML
<amp-iframe frameborder="0" width=#{width} height=#{width*ratio} sandbox="allow-scripts allow-same-origin" layout="responsive" src="#{src}"><amp-img layout="fill" width=800 height=600 src="images/placeholder.png"></amp-img></amp-iframe>
HTML
end
