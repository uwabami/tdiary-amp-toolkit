# coding: utf-8
#
# monky patching: replace <html> tag to <html amp>
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL-2+

require 'tdiary/base'

module TDiary
	class TDiaryBase
		alias_method :_orig_eval_rhtml, :eval_rhtml

		def eval_rhtml( prefix = '' )
			html = _orig_eval_rhtml(prefix)
			is_update = File.basename($0) == 'update.rb'

			html.sub!(/<html(?: lang="(ja|en)-(?:JP|US)")?>/) do
				# $1 には 'ja' か 'en' が入る。なければ nil
				attr_lang = $1 ? " lang=#{$1}" : ""
				attr_amp  = is_update ? "": " ⚡"
				"<html#{attr_amp}#{attr_lang} data-theme=\"light\">"
			end
			unless is_update
				html.sub!(/^<head>/,'<head prefix="og:http://ogp.me/ns# fb:http://ogp.me/ns/fb# article:http://ogp.me/ns/article#">')
			end
			html.sub!(/^\t(<meta name="generator" content="tDiary 5.1.0">)/,"\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n\t\\1")
			html.sub!(/(width=device-width,initial-scale=1)/,'\\1,minimum-scale=1')
			html.sub!(/^<div class="whole-content">\n\n/,'')
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
