# embed iframe
#
# usage:
#   amp_iframe(src, width, height)
#

unless respond_to?(:author_mail_tag_amp_iframe)
  alias :author_mail_tag_amp_iframe :author_mail_tag
end
def author_mail_tag()
  h = author_mail_tag_amp_iframe
  h += iframe_prefetch if check_iframe_needed
  h
end

unless respond_to?(:robot_control_amp_iframe)
  alias :robot_control_amp_iframe :robot_control
end
def robot_control()
  h = robot_control_amp_iframe
  h += iframe_async if check_iframe_needed
  h
end

def iframe_prefetch
  %Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-iframe-0.1.js">|
end

def iframe_async
  %Q|\n\t<script async custom-element="amp-iframe" src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>|
end

def check_iframe_needed()
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
  return iframe_on
end

def amp_iframe(src = nil, width = nil, ratio = nil)
  width ||= 100
  ratio ||= 1
  <<-HTML
<amp-iframe frameborder="0" width=#{width} height=#{width*ratio} sandbox="allow-scripts allow-same-origin" layout="responsive" src="#{src}"><amp-img layout="fill" width=800 height=600 src="images/placeholder.png"></amp-img></amp-iframe>
HTML
end
# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
