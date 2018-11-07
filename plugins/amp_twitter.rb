#
# Display tweet by amp-twitter
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# usage:
#   <%= amp_twitter "tweeetid" %>
#
add_header_proc do
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
	if twitter_on
		%Q|\n	<script async custom-element="amp-twitter" src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>|
	end
end

def amp_twitter(tweetid = nil)
	%Q|<amp-twitter data-tweetid=#{tweetid} width=800 height=600 layout="responsive"></amp-twitter>|
end


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
