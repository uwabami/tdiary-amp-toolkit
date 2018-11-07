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
		header  = %Q|\n	<script async custom-element="amp-geo" src="https://cdn.ampproject.org/v0/amp-geo-0.1.js"></script>|
		header += %Q|\n	<script async custom-element="amp-consent" src="https://cdn.ampproject.org/v0/amp-consent-0.1.js"></script>|
		header += %Q|\n	<script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>|
	end
end

def amp_google_analytics_consent
	amp_google_analytics_consent = %Q|<!-- amp_google_consent -->\n|
	if /^(?:latest|day|month|nyear|search)$/ =~ @mode
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
	<amp-analytics type="googleanalytics">
	<script type="application/json">
	{
	  "vars": {
	    "account": "UA-#{@conf['google_analytics.profile']}"
	  },
	  "triggers": {
	    "trackPageview": {
	      "on": "visible",
	      "request": "pageview"
	    }
	  }
	}
	</script>
	</amp-analytics>
EOS
	end
end

add_conf_proc( 'google_analytics', 'Google Analytics' ) do
	if @mode == 'saveconf' then
		@conf['google_analytics.profile'] = @cgi.params['google_analytics.profile'][0]
	end
	r = <<-HTML
	  	<h3>Google Analytics Profile</h3>
			<p>set your Profile ID (NNNNN-N)</p>
		<p><input name="google_analytics.profile" value="#{h @conf['google_analytics.profile']}"></p>
		<h3>Important note</h3>
		<p>Please insert &lt;%= amp_google_analytics_consent %&gt; into your header for GDPR. </p>
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
