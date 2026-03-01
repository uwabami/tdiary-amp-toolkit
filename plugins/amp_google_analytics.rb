# coding: utf-8
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
# insert your header <%= amp_google_analytics_consent %> for GDPR.

$debug = false

unless respond_to?(:author_mail_tag_amp_google_analytics)
  alias :author_mail_tag_amp_google_analytics :author_mail_tag
end
def author_mail_tag
	h = author_mail_tag_amp_google_analytics
	h += %Q|\n\t<!-- amp preload: google analytics -->| if $debug
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		h += %Q|\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-geo-0.1.js">\n|
		h += %Q|\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-consent-0.1.js">\n|
		h += %Q|\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-analytics-0.1.js">|
	end
	h += %Q|\n\t<!-- /amp preload: google analytics -->| if $debug
	h
end
unless respond_to?(:robot_control_amp_google_analytics)
  alias :robot_control_amp_google_analytics :robot_control
end
def robot_control
	h = robot_control_amp_google_analytics
	h += %Q|\n\t<!-- amp script: google analytics -->| if $debug
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		h += %Q|\n\t<script async custom-element="amp-geo" src="https://cdn.ampproject.org/v0/amp-geo-0.1.js"></script>\n|
		h += %Q|\t<script async custom-element="amp-consent" src="https://cdn.ampproject.org/v0/amp-consent-0.1.js"></script>\n|
		h += %Q|\t<script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>|
	end
	h += %Q|\n\t<meta name="amp-consent-blocking" content="amp-analytics">| if $debug
	h
end

def amp_google_analytics_consent
	amp_google_analytics_consent = ''
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		amp_google_analytics_consent = %Q|\t<!-- amp_google_consent -->\n| if $debug
		amp_google_analytics_consent << <<-EOS
	<amp-geo layout="nodisplay">
		<script type="application/json">
		{
			"ISOCountryGroups": {
				"eea": [ "at", "be", "bg", "cy", "cz", "de", "dk", "ee", "es", "fi",
							"fr", "gb", "gr", "hr", "hu", "ie", "is", "it", "li", "lt",
							"lu", "lv", "mt", "nl", "no", "pl", "pt", "ro", "se", "si",
							"sk"]
			}
		}
		</script>
	</amp-geo>
	<amp-consent layout="nodisplay" id="consent-element">
		<script type="application/json">
		{
			"consents": {
				"my_consent": {
					"promptIfUnknownForGeoGroup": "eea",
					"promptUI": "consent-ui"
				}
			}
		}
		</script>
		<div id="consent-ui">
		<p>I use cookies to analyze how visitors use my website via Google Analytics:</p>
			<button on="tap:consent-element.accept" role="button">Accept</button>
			<button on="tap:consent-element.reject" role="button">Reject</button>
			<button on="tap:consent-element.dismiss" role="button">Dismiss</button>
		</div>
	</amp-consent>
EOS
	end
	amp_google_analytics_consent
end

add_footer_proc do
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
		<<-EOS
		<amp-analytics data-block-on-consent
							type="googleanalytics"
							config="#{@conf.base_url}/ga4.json"
							data-credentials="include"
							data-block-on-consent>
		  <script type="application/json">
			 {
				  "vars": {
						"GA4_MEASUREMENT_ID": "G-#{@conf['google_analytics.profile']}",
						"GA4_ENDPOINT_HOSTNAME": "www.google-analytics.com",
						"DEFAULT_PAGEVIEW_ENABLED": true,
						"GOOGLE_CONSENT_ENABLED": true,
						"WEBVITALS_TRACKING": false,
						"PERFORMANCE_TIMING_TRACKING": false
				  }
			 }
		  </script>
		</amp-analytics>
EOS
	end
end

add_conf_proc( 'amp_google_analytics', 'Google Analytics', 'etc' ) do
	if @mode == 'saveconf' then
		@conf['google_analytics.profile'] = @cgi.params['google_analytics.profile'][0]
	end
	r = <<-HTML
<h3>Google Analytics Profile</h3>
<p>set your GA4 ID, G-XXXXXXXXXX without "G-".</p>
<p><input name="google_analytics.profile" value="#{h @conf['google_analytics.profile']}"></p>
<h3>Important note</h3>
<ul>
  <li>Put "ga4.json" into "#{@conf.base_url}" </li>
  <li>You should insert &lt;%= amp_google_analytics_consent %&gt; into your header for GDPR. </li>
</ul>
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
