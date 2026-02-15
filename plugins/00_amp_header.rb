# coding: utf-8
#
# modify header contents for amp html
#
# Copyright (c) 2018 Youhei SASAKI <uwabami@gfd-dennou.org>
#
# You can redistribute it and/or modify it under GPL.
#
require 'rmagick'
require 'fileutils'

def doctype
	%Q[<!doctype html>]
end

def author_mail_tag
	%Q[<!-- amp preload(author mail tag) -->
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-geo-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-consent-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-analytics-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-form-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-font-0.1.js">
	<link rel="preconnect dns-prefetch" href="https://uwabami.junkhub.org/" crossorigin>
	<link rel="preload" as="font" type="font/woff2" href="/assets/fonts/AoyagiKouzanTSubset.woff2" crossorigin>
	<!-- /amp preload -->]
end

def robot_control
	if /^form|edit|preview|showcomment$/ =~ @mode then
		%Q|<meta name="robots" content="noindex,nofollow">|
	else
		%Q|<!-- robot control tag -->|
	end
end

## TODO
# --- OGP画像生成の設定 ---
OGP_CONFIG = {
	# 1. 保存先 (Webサーバが書き込める場所)
	output_dir: "/home/uwabami/public_html/log/images/ogp",
	# 2. Web公開用URLベース (http://.../images/ogp)
	base_url: "https://uwabami.junkhub.org/log/images/ogp",
	# 3. フォントパス (IPAexゴシック)
	font_path: '/usr/share/fonts/opentype/ipaexfont-gothic/ipaexg.ttf',
	# 4. アイコン画像のパス (サーバー上の絶対パス)
	icon_path: "/home/uwabami/public_html/log/images/top-large.png",

	# 5. デザイン設定
	theme_color: '#005BBB', # 青い帯の色
	text_color:  '#333333', # タイトル文字色
	bg_color:    'white'    # 背景色
}

# ----------------------------------------------------------------
# OGP画像生成メソッド (白背景・青帯・丸アイコン)
# ----------------------------------------------------------------
def generate_og_image_card(title, date_str)
	conf = OGP_CONFIG
	# 保存先ディレクトリの準備
	FileUtils.mkdir_p(conf[:output_dir]) unless File.exist?(conf[:output_dir])
	filename = "ogp_#{date_str}.png"
	file_path = File.join(conf[:output_dir], filename)
	public_url = "#{conf[:base_url]}/#{filename}"
	# キャッシュがあればURLを返して終了
	return public_url if File.exist?(file_path)
	# --- 描画開始 ---
	width, height = 1200, 630
	bar_height = 100
	image = Magick::Image.new(width, height)
	image.background_color = conf[:bg_color]
	image.erase!
	# 1. 上下の青い帯
	draw = Magick::Draw.new
	draw.fill = conf[:theme_color]
	draw.rectangle(0, 0, width, bar_height)
	draw.rectangle(0, height - bar_height, width, height)
	draw.draw(image)
	# 2. ヘッダ文字
	header_text = "#{date_str} / uwabami's diary".dup.force_encoding('UTF-8')
	draw.annotate(image, 0, 0, 40, 34, header_text) do |d|
		d.font = conf[:font_path]
		d.pointsize = 32
		d.fill = 'white'
		d.gravity = Magick::NorthWestGravity
		d.font_weight = Magick::BoldWeight
	end
	# 3. 【改善】メインタイトルの自動折り返し (caption 使用)
	# 左右に 100px ずつの余白を持たせた 1000px 幅の「テキスト箱」を作ります
	title_text = title.to_s.dup.force_encoding('UTF-8')
	title_layer = Magick::Image.read("caption:#{title_text}") { |opt|
		opt.size = "1000x350"          # タイトルエリアのサイズ
		opt.font = conf[:font_path]
		opt.pointsize = 70             # 基本サイズ (入り切らない場合は自動で小さくなる)
		opt.fill = conf[:text_color]
		opt.background_color = "none"  # 背景透明
		opt.gravity = Magick::CenterGravity
	}.first
	# 中央に合成
	image.composite!(title_layer, Magick::CenterGravity, Magick::OverCompositeOp)
	# 4. 【改善】アイコンの円形切り抜き合成
	if File.exist?(conf[:icon_path])
		begin
			icon_size = 80
			icon_src = Magick::Image.read(conf[:icon_path]).first
			icon_src.resize_to_fill!(icon_size, icon_size)
			# アイコン用のベースレイヤー(透明)
			icon_base = Magick::Image.new(icon_size, icon_size) { self.background_color = 'none' }
			# 丸い「型」を描く
			mask_draw = Magick::Draw.new
			mask_draw.fill = 'white'
			mask_draw.circle(icon_size/2, icon_size/2, icon_size/2, 0)
			mask_draw.draw(icon_base)
			# 型にアイコンを流し込む (SrcIn)
			icon_base.composite!(icon_src, Magick::CenterGravity, Magick::SrcInCompositeOp)
			# 本体に合成 (右下)
			image.composite!(icon_base, Magick::SouthEastGravity, 40, 10, Magick::OverCompositeOp)
			# 解放
			icon_src.destroy!
			icon_base.destroy!
			title_layer.destroy!
		rescue => e
			warn "OGP Icon Error: #{e.message}"
		end
	end
	# 保存
	image.write(file_path)
	image.destroy!
	return public_url
end


def ogp_tag
	# title
	h = %Q|<meta property="og:type" content="article">|
	ogp = {}
	top_image = (@conf.banner.nil? || @conf.banner == '') ? File.join(@conf.base_url, "#{theme_url}/ogimage.png") : @conf.banner
	# options
	ogp['og:site_name'] = @conf.html_title
	ogp['og:description'] = short_desc.gsub(/&#8230;/,'')
	case @mode
	when 'day', 'latest'
		date_key = @date.strftime('%Y%m%d')
		diary = @diaries[date_key]
		if diary.nil? && !@diaries.empty?
			date_key = @diaries.keys.sort.last
			diary = @diaries[date_key]
		end
		subtitles = []
		if diary
			diary.each_section do |section|
				if section.subtitle && !section.subtitle.empty?
					clean_subtitle = section.subtitle.gsub(/<[^>]+>/, '')
					clean_subtitle.sub!(/^\s*(\[[^\]]+\])+\s*/, '')
					# # for org-style
					clean_subtitle.sub!(/^\s*\*+\s*/, '')
					clean_subtitle.sub!(/\s*(:[^:]+)+:\s*$/, '')
					clean_subtitle.strip!
					subtitles << clean_subtitle unless clean_subtitle.empty?
				end
			end
		end
		if subtitles.empty?
			ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		else
			ogp['og:title'] = subtitles.join(' / ')
		end
		ogp['og:url'] = URI.join(@conf.base_url, anchor(date_key))
		begin
			ogp['og:image'] = generate_og_image_card(ogp['og:title'], date_key)
		rescue => e
			ogp['og:image'] = top_image
		end
	when 'nyear'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@cgi.params['date'][0].to_s))
		image = (@conf.banner.nil? || @conf.banner == '') ? File.join(@conf.base_url, "#{theme_url}/ogimage.png") : @conf.banner
		ogp['og:image'] = top_image
	when 'month'
		ogp['og:title'] = title_tag.gsub(/<[^>]*>/, "")
		ogp['og:url'] = URI.join(@conf.base_url, anchor(@date.strftime('%Y%m')))
		image = (@conf.banner.nil? || @conf.banner == '') ? File.join(@conf.base_url, "#{theme_url}/ogimage.png") : @conf.banner
		ogp['og:image'] = top_image
	else
#		ogp['og:type'] = 'website'
#		ogp['og:url'] = uri
	end
	if @conf['twitter.user']
		ogp['twitter:card'] = 'summary_large_image'
		ogp['twitter:site'] = "@#{@conf['twitter.user']}"
		ogp['twitter:url' ] = ogp['og:url']
		ogp['twitter:title'] = ogp['og:title']
		ogp['twitter:description'] = ogp['og:description']
		# ogp['twitter:image'] = "@#{@conf['twitter.image']}"
		ogp['twitter:image'] = ogp['og:image']
	end
	if @conf['facebook.appid']
		ogp['fb:appid'] = "#{conf['facebook.appid']}"
	end
	ogp.map { |k, v|
		h << %Q|\n	<meta property="#{k}" content="#{h(v)}">|
	}
	h += <<-LD_JSON_HEAD
\n\t<script type="application/ld+json">
	{
		"@context": "http://schema.org",
		"@type": "BlogPosting",
			"mainEntityOfPage":{
				"@type":"WebPage",
				"@id":"#{@conf.base_url}"
			},
			"headline": "#{ogp['og:title']}",
			"image": {
				"@type": "ImageObject",
				"url": "https://uwabami.junkhub.org/ogimage_640x480.png",
				"height": 480,
				"width": 640
			},
LD_JSON_HEAD
	case @mode
	when 'day'
		h <<%Q|			"datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
		h <<%Q|			"dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
	when 'latest'
		h <<%Q|			"datePublished": "#{@diaries[@date.strftime('%Y%m%d')].date.iso8601}",\n|
		h <<%Q|			"dateModified": "#{@diaries[@date.strftime('%Y%m%d')].last_modified.iso8601}",\n|
	when 'month'
     h <<%Q|			"datePublished": "#{@diaries.sort[0][1].date.iso8601}",\n|
     h <<%Q|			"dateModified": "#{@diaries.sort[-1][1].date.iso8601}",\n|
	when 'nyear'
     h <<%Q|			"datePublished": "#{@diaries.sort[0][1].date.iso8601}",\n|
     h <<%Q|			"dateModified": "#{@diaries.sort[-1][1].date.iso8601}",\n|
	end
	h += <<-LD_JSON_BOTTOM.chomp
			"author": {
				"@type": "Person",
				"name": "#{@conf.author_name}",
				"image": "https://uwabami.junkhub.org/log/images/face.jpg"
			},
			"publisher": {
				"@type": "Organization",
				"name": "#{@conf.author_name}",
				"logo": {
					"@type": "ImageObject",
					"url": "#{ogp['og:image']}",
					"height": 240,
					"width": 320
				}
			},
		"description": "#{ogp['og:description']}"
	}
	</script>
LD_JSON_BOTTOM
end

add_header_proc do
	header = "	<!-- #{@mode} -->\n"
	case @mode
	when 'latest'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'day'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m%d')))}">|
	when 'month'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@date.strftime('%Y%m')))}">|
	when 'nyear'
		header += %Q|	<link rel="canonical" href="#{URI.join(@conf.base_url, anchor(@cgi.params['date'][0].to_s))}">|
	else
		''
	end
	header += %Q|\n\t<script async src=\"https://cdn.ampproject.org/v0.js\"></script>|
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
