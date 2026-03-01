# amp_export_entry_json.rb
# AMP (amp-list) 用に「最近の日記(最新10件)」と「アーカイブ(月別一覧)」の JSON を出力する

require 'json'
@display_names = %w(latest day month nyear categoryview preview)
$debug = false

unless respond_to?(:author_mail_tag_amp_export_json)
  alias :author_mail_tag_amp_export_json :author_mail_tag
end
def author_mail_tag()
	r = author_mail_tag_amp_export_json
	r += %Q|\n\t<!-- ddd amp preload by amp_export_json -->| if $debug
	r += %Q[\n\t<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-list-0.1.js">
	<link rel="preload" as="script" href="https://cdn.ampproject.org/v0/amp-mustache-0.2.js">]
	r += %Q|\n\t<!-- /ddd amp preload by amp_export_json -->| if $debug
	r
end
unless respond_to?(:robot_control_amp_export_json)
  alias :robot_control_amp_export_json :robot_control
end
def robot_control
	h = robot_control_amp_export_json
	h += %Q|\n\t<!-- robot contool amp_export_json -->| if $debug
	if @display_mode.include?(@mode) then
		h += %Q|\n\t<script async custom-element="amp-list" src="https://cdn.ampproject.org/v0/amp-list-0.1.js"></script>\n|
		h += %Q|\t<script async custom-template="amp-mustache" src="https://cdn.ampproject.org/v0/amp-mustache-0.2.js"></script>|
		h += %Q|\t<!-- /robot contool amp_export_json -->| if $debug
	end
	h
end

unless respond_to?(:navi_for_amp)
	alias :navi_for_amp :navi
end
unless respond_to?(:navi_index_for_amp)
	alias :navi_index_for_amp :navi_index
end
unless respond_to?(:navi_latest_for_amp)
	alias :navi_latest_for_amp :navi_latest
end
unless respond_to?(:navi_oldest_for_amp)
	alias :navi_oldest_for_amp :navi_oldest
end
unless respond_to?(:navi_update_for_amp)
	alias :navi_update_for_amp :navi_update
end
unless respond_to?(:navi_edit_for_amp)
	alias :navi_edit_for_amp :navi_edit
end
unless respond_to?(:navi_preference_for_amp)
	alias :navi_preference_for_amp :navi_preference
end
unless respond_to?(:navi_prev_diary_for_amp)
	alias :navi_prev_diary_for_amp :navi_prev_diary
end
unless respond_to?(:navi_next_diary_for_amp)
	alias :navi_next_diary_for_amp :navi_next_diary
end
unless respond_to?(:navi_prev_month_for_amp)
	alias :navi_prev_month_for_amp :navi_prev_month
end
unless respond_to?(:navi_next_month_for_amp)
	alias :navi_next_month_for_amp :navi_next_month
end
unless respond_to?(:navi_prev_nyear_for_amp)
	alias :navi_prev_nyear_for_amp :navi_prev_nyear
end
unless respond_to?(:navi_next_nyear_for_amp)
	alias :navi_next_nyear_for_amp :navi_next_nyear
end
unless respond_to?(:navi_prev_ndays_for_amp)
	alias :navi_prev_ndays_for_amp :navi_prev_ndays
end
unless respond_to?(:navi_next_ndays_for_amp)
	alias :navi_next_ndays_for_amp :navi_next_ndays
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


def navi_amp_customized
	r = ''
	r += %Q|\n<!-- html navi -->\n|
	r += %Q|<nav>|
	r += %Q|#{navi_user.gsub(/<span class="adminmenu"><a href="https:\/\/uwabami.github.io\/index.html">トップ<\/a><\/span>/,'').gsub(/<span class="adminmenu">/, "<ul><li>").gsub(/<\/span>/,"</li></ul>")}|
	r += %Q|</nav>\n|
end

def navi_amp
	# default
	r = navi_amp_customized
	# 最新とその直線は amp-mustache で処理するので上書き
	if @mode == 'day' || @mode == 'latest'
		date_key = @date.strftime('%Y%m%d')
		output_dir = @conf['amp_json.output_dir'] || @conf.data_path
		recent_json_path = File.join(output_dir, 'recent_entries.json')
		target_date_key = nil
		is_boundary = false
		# recent_entries.json を読み込んで、ブログ全体の最新2件を特定する
		if File.exist?(recent_json_path)
			recent_data = JSON.parse(File.read(recent_json_path))
			latest_keys = recent_data["items"].map { |item| item["date"].gsub('/', '') }
			if @mode == 'day' && @date
				current_key = @date.strftime('%Y%m%d')
				# 今見ているページが「最新」か「その1つ前」なら AMP 化の対象にする
				if latest_keys[0..1].include?(current_key)
					target_date_key = current_key
					is_boundary = true
				end
			elsif @mode == 'latest'
				# latest モード時は「最新の日付」のナビゲーションとして振る舞わせる
				target_date_key = latest_keys[0]
				is_boundary = true
			end
		end
		if is_boundary && target_date_key
			json_path = File.join(output_dir, "navi_#{date_key}.json")
			if File.exist?(json_path)
				json_url = "/log/json/navi_#{date_key}.json"
				# 上書き!
				r = %Q|\t<!-- json navi -->\n|
				r += <<-NAVI_HTML
  <amp-list src="#{json_url}" layout="fixed-height" height="42">
    <template type="amp-mustache">
      <nav>
      {{#has_prev}}
        <ul><li><a href="{{prev_url}}" rel="next">&laquo;{{prev_date_str}}</a></li></ul>
      {{/has_prev}}
        <ul><li><a href="./">最新</a></li></ul>
      {{#has_next}}
        <ul><li><a href="{{next_url}}" rel="prev">{{next_date_str}}&raquo;</a></li></ul>
      {{/has_next}}
      {{^has_next}}
        <ul><li style="visibility: hidden">0000/00/00&raquo;</li></ul>
      {{/has_next}}
      </nav>
    </template>
  </amp-list>
NAVI_HTML
			end
		end
	end
	r
end

def amp_recent_list()
	r = <<-LIST_EOF
<amp-list class="recent-list" src="/log/json/recent_entries.json" layout="fixed-height" height="400" style="overflow-y: auto;">
      <template type="amp-mustache">
        <div class="entry-item">
          <a href="{{date_url}}">{{date}}</a>
          <ul>
          {{#sections}}
            <li><a href="{{url}}">{{subtitle}}</a></li>
          {{/sections}}
          </ul>
        </div>
      </template>
    </amp-list>
LIST_EOF
end

def amp_calendar()
	r = <<-CALENDAR_EOF
<amp-list class="calendar" src="/log/json/archive_list.json" layout="fixed-height" height="500">
  <template type="amp-mustache">
    <div class="archive-year">
      {{year}} |
      {{#months}}
        <a href="{{url}}">{{month}}</a> |
      {{/months}}
    </div>
  </template>
  </amp-list>
CALENDAR_EOF
end

add_update_proc do
	limit = 5
	# ----------------------------------------------------------------------
	# ディレクトリ準備
	# ----------------------------------------------------------------------
	output_dir = @conf['amp_json.output_dir'] || @conf.data_path
	# ----------------------------------------------------------------------
	# 「一覧」（アーカイブ）の作成 → カレンダーで利用
	# ----------------------------------------------------------------------
	archive_entries = []
	@years.keys.sort.reverse_each do |year|
		months_data = []
		@years[year].sort.each do |month|
			months_data << {
				"month" => month,
				"url"	  => "#{@conf.base_url}#{year}#{month}.html"
			}
		end
		archive_entries << {
			"year"	=> year.to_s,
			"months" => months_data
		}
	end
	begin
		File.write(File.join(output_dir, 'archive_list.json'),	{ "items" => archive_entries }.to_json)
	rescue => e
		File.write(File.join(@conf.data_path, 'amp_json_error.log'), "[#{Time.now}] #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
	end
	# ----------------------------------------------------------------------
	# 「最近の日記」（最新5件・セクション分割）
	# ----------------------------------------------------------------------
	recent_entries = []
	catch(:done) do
		@years.keys.sort.reverse_each do |year|
			@years[year].sort.reverse_each do |month|
				m = DiaryContainer::find_by_month(@conf, "#{year}#{month}")
				next unless m
				m.diaries.keys.sort.reverse_each do |date|
					diary = m.diaries[date]
					next unless diary.visible?
					sections_data = []
					idx = 1
					diary.each_section do |section|
						subtitle = section.subtitle || "無題"
						subtitle = subtitle.gsub(/<[^>]+>/, '').sub(/^\s*\*+\s*/, '').sub(/\s*(:[^:]+)+:\s*$/, '')
						sections_data << {
							"subtitle" => subtitle,
							"url" => "#{@conf.base_url}#{anchor(date)}#p#{sprintf('%02d', idx)}"
						}
						idx += 1
					end
					recent_entries << {
						"date"	  => diary.date.strftime('%Y/%m/%d'),
						"date_url" => "#{@conf.base_url}#{anchor(date)}",
						"sections" => sections_data
					}
					# 指定件数に達したら完全脱出
					throw :done if recent_entries.size >= limit
				end
			end
		end
	end
	begin
		File.write(File.join(output_dir, 'recent_entries.json'), { "items" => recent_entries }.to_json)
	rescue => e
		File.write(File.join(@conf.data_path, 'amp_json_error.log'), "[#{Time.now}] #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
	end
	# ----------------------------------------------------------------------
	#  ページ個別ナビゲーション (navi/navi_YYYYMMDD.json) の生成
	# ----------------------------------------------------------------------
	recent_entries.first(2).each_with_index do |current_item, idx|
		current_date_key = current_item["date"].gsub('/', '')
		next_item = (idx > 0) ? recent_entries[idx - 1] : nil
		prev_item = (idx + 1 < recent_entries.size) ? recent_entries[idx + 1] : nil
		amp_navi_data = {
			"has_prev" => !prev_item.nil?,
			"prev_url" => prev_item ? prev_item["date_url"] : "",
			"prev_date_str" => prev_item ? prev_item["date"] : "",
			"has_next" => !next_item.nil?,
			"next_url" => next_item ? next_item["date_url"] : "",
			"next_date_str" => next_item ? next_item["date"] : ""
		}
		begin
			File.write(File.join(output_dir, "navi_#{current_date_key}.json"), { "items" => [amp_navi_data] }.to_json)
		rescue => e
			File.write(File.join(@conf.data_path, 'amp_json_error.log'), "[#{Time.now}] #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
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
