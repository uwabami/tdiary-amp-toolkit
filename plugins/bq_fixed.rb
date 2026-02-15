# bq.rb
#
# bq: blockquoteを使った引用を生成する
#   パラメタ:
#     src:   引用するテキスト
#     title: 引用元のタイトル
#     url:   引用元のURL
#
#   引用元タイトルをうまく表示するには、スタイルシートでp.sourceを
#   定義する必要があります。スタイルの例:
#
#       p.source {
#          margin-top: 0.3em;
#          text-align: right;
#          font-size: 90%;
#       }
#
# Copyright (C) 2002 s.sawada <moonwave@ba2.so-net.ne.jp>
# You can redistribute it and/or modify it under GPL2 or any later version.
#
def bq( src, title = nil, url = nil )
	if url
		result = %Q[</p><blockquote cite="#{h url}" title="#{h title}">\n]
	elsif title
		result = %Q[</p><blockquote title="#{h title}">\n]
	else
		result = %Q[</p><blockquote>\n]
	end
	result << %Q[<p>#{src.gsub( /\n/, "</p>\n<p>" )}</p>\n].sub( %r[<p></p>], '' )
	if url
		cite = %Q[<cite><a href="#{h url}" title="#{h title}">#{title}</a></cite>]
		result << %Q[<p class="source">[from:#{cite}]</p>\n]
	elsif title
		cite = %Q[<cite>#{title}</cite>]
		result << %Q[<p class="source">[from:#{cite}]</p>\n]
	end
	result << %Q[</blockquote>\n<p>]
	result
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
