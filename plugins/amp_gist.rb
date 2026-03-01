# show code snippet via gist.github.com
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_gist gist_id, height %>
#

unless respond_to?(:author_mail_tag_amp_gist)
  alias :author_mail_tag_amp_gist :author_mail_tag
end
def author_mail_tag()
	h = author_mail_tag_amp_gist
	h += gist_prefetch if check_gist_needed
	h
end

unless respond_to?(:robot_control_amp_gist)
  alias :robot_control_amp_gist :robot_control
end
def robot_control()
	h = robot_control_amp_gist
	h += gist_async if check_gist_needed
	h
end


def gist_prefetch()
	h = %Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-gist-0.1.js">|
end

def gist_async()
	h = %Q|\n\t<script async custom-element="amp-gist" src="https://cdn.ampproject.org/v0/amp-gist-0.1.js"></script>|
end

def amp_gist( gist_id, height )
	<<-HTML
<amp-gist
    data-gistid="#{gist_id}"
    layout="fixed-height"
    height="#{height}">
</amp-gist>
HTML
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
