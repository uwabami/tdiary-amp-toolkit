# coding: utf-8
# Show navi for basscss theme
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
# insert your header <%= amp_google_analytics_consent %> for GDPR.

add_header_proc do
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		header  = %Q|\n	<script async custom-element="amp-auto-ads" src="https://cdn.ampproject.org/v0/amp-auto-ads-0.1.js"></script>|
	end
end

def amp_google_adsense
	amp_google_adsense_contents = %Q|\t<!-- amp_google_adsense -->\n|
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		amp_google_adsense_contents << <<-EOS
	<amp-auto-ads type="adsense" data-ad-client="#{@conf['amp_google_adsense.id']}"></amp-auto-ads>
EOS
	end
	amp_google_adsense_contents.chomp
end

add_conf_proc( 'amp_google_adsense', 'Google Adsense(AMP)' ) do
	if @mode == 'saveconf' then
		@conf['amp_google_adsense.id'] = @cgi.params['amp_google_adsense.id'][0]
	end
	r = <<-HTML
	  	<h3>Google Adsense(AMP)</h3>
			<p>set your adsense id (ca-pub-XXXXXXXXXXX)</p>
		<p><input name="amp_google_adsense.id" value="#{h @conf['amp_google_adsense.id']}"></p>
	HTML
	r
end


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
