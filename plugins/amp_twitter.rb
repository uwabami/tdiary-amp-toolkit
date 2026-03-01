#
# Display tweet by amp-twitter
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_twitter "tweeetid" %>
#
unless respond_to?(:author_mail_tag_amp_twitter)
  alias :author_mail_tag_amp_twitter :author_mail_tag
end
def author_mail_tag()
	h = author_mail_tag_amp_twitter
	h += twitter_prefetch if check_twitter_needed
	h
end

unless respond_to?(:robot_control_amp_twitter)
  alias :robot_control_amp_twitter :robot_control
end
def robot_control()
	h = robot_control_amp_twitter
	h += twitter_async if check_twitter_needed
	h
end

def twitter_prefetch
	%Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-twitter-0.1.js">|
end
def twitter_async
	%Q|\n\t<script async custom-element="amp-twitter" src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>|
end

def check_twitter_needed
	twitter_on = false
	case @mode
	when 'latest'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_twitter\s.+?%>/
			twitter_on = true
		end
	when 'day'
		if @diaries[@date.strftime('%Y%m%d')].to_html =~/<%=amp_twitter\s.+?%>/
			twitter_on = true
		end
	when 'month'
		@diaries.each do |diary|
			if diary[1].to_html =~/<%=amp_twitter\s.+?%>/
				twitter_on = true
			end
		end
	when 'nyear'
		@diaries.each do |diary|
			if diary[1].to_html =~/<%=amp_twitter\s.+?%>/
				twitter_on = true
			end
		end
	end
	return twitter_on
end

def amp_twitter(tweetid = nil)
	%Q|<amp-twitter data-tweetid=#{tweetid} width=550 height=600 layout="responsive"></amp-twitter>|
end


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
