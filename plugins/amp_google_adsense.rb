#
# Google AdSense plugin for tDiary
#
# Copyright (C) 2004 Kazuhiko <kazuhiko@fdiary.net>
# You can redistribute it and/or modify it under GPL2.
#
# modified by TADA Tadashi <t@tdtds.jp>
#
add_header_proc do
  adsense_on = false
  case @mode
  when 'day'
    adsense_on = true
  # when 'month'
  #   adsense_on = true
  # when 'nyear'
  #   adsense_on = true
  end
  if adsense_on
        %Q|\n	<script async custom-element="amp-ad" src="https://cdn.ampproject.org/v0/amp-ad-0.1.js"></script>|
#    %Q|\n   <script async custom-element="amp-auto-ads" src="https://cdn.ampproject.org/v0/amp-auto-ads-0.1.js"></script>|
  end
end

add_section_leave_proc do |date, index|
  unless feed? or bot?
	if @mode == 'day' and index == 1 then
      r = <<-EOF
<amp-ad
   layout="fixed-height"
   height=100
   type="adsense"
   data-ad-client="ca-pub-2021079813689026"
   data-ad-slot="4097263635">
</amp-ad>
EOF
      r
    end
  end
end
