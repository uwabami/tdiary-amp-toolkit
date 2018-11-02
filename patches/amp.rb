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
			.gsub(/^<html lang="ja-JP">/,'<html amp lang=ja>')
			.gsub(/^<html lang="en-US">/,'<html amp lang=en>')
			.gsub(/^<html>/,'<html amp>')
			.gsub(/^<head>/,'<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# article: http://ogp.me/ns/article#">')
			.gsub(/^\t(<meta name="generator")/,
					"\t<script async src=\"https://cdn.ampproject.org/v0.js\"></script>\n\t\\1")
			.gsub(/(width=device-width,initial-scale=1)/,'\\1,minimum-scale=1')
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
