# coding: utf-8
#
# monky patching: replace <html> tag to <html amp>
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.

require 'tdiary/base'

module TDiary
  class TDiaryBase

	 alias_method :_orig_eval_rhtml, :eval_rhtml
	 def eval_rhtml( prefix = '' )
		_orig_eval_rhtml( prefix )
			.gsub(/^<html lang="ja-JP">/,'<html ⚡ lang=ja data-theme="light">')
			.gsub(/^<html lang="en-US">/,'<html ⚡ lang=en data-theme="light">')
			.gsub(/^<html>/,'<html ⚡ data-theme="light">')
			.gsub(/^<head>/,'<head prefix="og:http://ogp.me/ns# fb:http://ogp.me/ns/fb# article:http://ogp.me/ns/article#">')
			.gsub(/^\t(<meta name="generator" content="tDiary 5.1.0">)/,"\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n\t\\1")
			.gsub(/(width=device-width,initial-scale=1)/,'\\1,minimum-scale=1')
			.gsub(/^<div class="whole-content">\n\n/,'')
	 end
  end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
