# coding: utf-8
# Show navi for picocss theme
#
# Copyright (c) 2023 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.

add_header_proc do
  header = ''
  header += %Q|\t<script async custom-element="amp-form" src="https://cdn.ampproject.org/v0/amp-form-0.1.js"></script>\n|
  header += %Q|\t<script async custom-element="amp-font" src="https://cdn.ampproject.org/v0/amp-font-0.1.js"></script>\n|
  header
end


def navi_index; 'トップ'; end
def navi_latest; '最新'; end
def navi_oldest; ''; end
def navi_update; ''; end
def navi_edit; ''; end
def navi_preference; ''; end
def navi_prev_diary(date); "#{date.strftime(@conf.date_format)}"; end
def navi_next_diary(date); "#{date.strftime(@conf.date_format)}"; end
def navi_prev_month; ""; end
def navi_next_month; ""; end
def navi_prev_nyear(date); "#{date.strftime('%m-%d')}"; end
def navi_next_nyear(date); "#{date.strftime('%m-%d')}"; end
def navi_prev_ndays; "前の#{@conf.latest_limit}日"; end
def navi_next_ndays; "次の#{@conf.latest_limit}日"; end

def navi_only
  navi_only = ''
  navi_only += %Q|#{navi_user.gsub(/<span class="adminmenu"><a href="https:\/\/uwabami.github.io\/index.html">トップ<\/a><\/span>/,'').gsub(/<span class="adminmenu">/, "<ul><li>").gsub(/<\/span>/,"</li></ul>")}|
  if navi_only.scan("<ul><li>").length <= 2
    navi_only = navi_only + %Q|<ul><li>&emsp;</li></ul>|
  end
  navi_only += %Q|\n|
  navi_only
end
def google_search
  gsearch = <<"EOS"
<li>
<form method="GET" action="https://www.google.com/cse" target="_top">
<input name="cx" type="hidden" value="017455171263919107349:3ljlf8jzf3m" />
<input name="ie" type="hidden" value="UTF-8" />
<input type="search" placeholder="検索" name="q" required>
</form>
</li>
EOS
  gsearch
end
def navi
  navi = ''
  navi += %Q| <div class="wrapper container" id="wholepage">\n|
  navi += %Q| <header>\n|
  navi += %Q|   <nav>\n|
  navi += %Q|     <ul>\n|
  navi += %Q|       <li>\n|
  navi += %Q|         <a href="#{@conf.index_page}">\n|
  navi += %Q|           <amp-img layout="fixed"\n|
  navi += %Q|                    width="1.2rem"\n|
  navi += %Q|                    height="1.2rem"\n|
  navi += %Q|                    src="#{@conf.base_url}images/top.webp"\n|
  navi += %Q|                    alt="About"\n|
  navi += %Q|                    id="top">\n|
  navi += %Q|             <amp-img fallback\n|
  navi += %Q|                      layout="fixed"\n|
  navi += %Q|                      width="1.2rem"\n|
  navi += %Q|                      height="1.2rem"\n|
  navi += %Q|                      src="#{@conf.base_url}images/top.jpg"\n|
  navi += %Q|                      alt="About"\n|
  navi += %Q|                      id="top">\n|
  navi += %Q|             </amp-img>\n|
  navi += %Q|           </amp-img>\n|
  navi += %Q|         </a>\n|
  navi += %Q|       </li>\n|
  navi += %Q|     </ul>\n|
  navi += %Q|     <ul>\n|
  navi += %Q|#{google_search}\n|
  navi += %Q|     </ul>\n|
  navi += %Q|  </nav>\n|
  navi += %Q|  <nav>\n|
  navi += %Q|#{navi_only} \n|
  navi += %Q|  </nav>\n|
  navi += %Q| </header> \n|
  navi += %Q| <main role="main">\n|
  navi += %Q|   <div class="content">\n|
  navi += %Q|   <h1 class="title-font">#{@conf.html_title}</h1>\n|
  navi
end

def hide_comment_day_limit
  return false
end

#
# make comment form
#
def comment_description
  begin
	if @conf.options['comment_description'].length > 0 then
	  return @conf.options['comment_description']
	end
  rescue
  end
  comment_description_default
end

def comment_form_text
  r = ''
#   unless @diary then
# 	@diary = @diaries[@date.strftime( '%Y%m%d' )]
# 	return '' unless @diary
#   end
#   r = ''
#   unless @conf.hide_comment_form then
#     r = <<-FORM
#             <div class="form">
# FORM
# 	if @diary.count_comments( true ) >= @conf.comment_limit_per_day then
# 	  r << <<-FORM
# 				<div class="caption"><a name="c">#{comment_limit_label}</a></div>
# FORM
# 	else
# 	  r << <<-FORM
# 				<div class="caption"><a name="c">#{comment_description}</a></div>
# 				<form class="comment" name="comment-form" method="post" target="_top" action-xhr="#{h @conf.index}"><div>
# 				<input type="hidden" name="date" value="#{ @date.strftime( '%Y%m%d' )}">
# 				<div class="field name">
# 					#{comment_name_label}:<input class="field" name="name" value="#{h( @conf.to_native(@cgi.cookies['tdiary'][0] || '' ))}">
# 				</div>
# 				<div class="field mail">
# 					#{comment_mail_label}:
# 					<input class="field" name="mail" value="#{h( @cgi.cookies['tdiary'][1] || '' )}">
# 				</div>
# 				<div class="textarea">
# 					#{comment_body_label}: <textarea name="body" cols="60" rows="5"></textarea>
# 				</div>
# 				<div class="button">
# 					<input type="submit" name="comment" value="#{h comment_submit_label}">
# 				</div>
# 				</div></form>
# FORM
# 	end
# 	r << <<-FORM
# 			</div>
# FORM
#   end
#  r
end
