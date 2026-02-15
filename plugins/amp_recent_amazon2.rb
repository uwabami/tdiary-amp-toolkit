# -*- coding: utf-8 -*-
# recent_amazon2: 最近amazonプラグインで表示した商品のリストを表示
#
#   @secure = true な環境では動作しません．
#
#   プラグインの再展開機能を利用していますので、
#   tdiaty.conf の @options['apply_plugin'] を true にしてください。
#
# Copyright (c) 2005-2007 valda <valda@underscore.jp>
# Distributed under the GPL
#

eval( <<MODIFY_CLASS, TOPLEVEL_BINDING )
module TDiary
  class TDiaryMonth
    attr_reader :diaries
  end
end
MODIFY_CLASS

def recent_amazon2_init
  @conf['recent_amazon2.cache'] ||= "#{@cache_path}/recent_amazon2"
  @conf['recent_amazon2.items'] ||= 10
  @conf['recent_amazon2.imgsize'] = @conf['amazon.imgsize'] if @conf['recent_amazon2.imgsize'].nil?
  @conf['recent_amazon2.hidename'] = @conf['amazon.hidename'] if @conf['recent_amazon2.hidename'].nil?
  @conf['recent_amazon2.nodefault'] = @conf['amazon.nodefault'] if @conf['recent_amazon2.nodefault'].nil?
end

def recent_amazon2_generate_html
  recent_amazon2_init

  cache = @conf['recent_amazon2.cache']
  items = @conf['recent_amazon2.items'].to_i
  imgsize = @conf['recent_amazon2.imgsize']
  hidename = @conf['recent_amazon2.hidename']
  nodefault = @conf['recent_amazon2.nodefault']
  isbns = []
  cgi = CGI::new
  def cgi.referer; nil; end

  catch(:exit) {
    @years.keys.sort.reverse_each do |year|
      @years[year].sort.reverse_each do |month|
        cgi.params['date'] = ["#{year}#{month}"]
        m = TDiaryMonth::new(cgi, '', @conf)
        m.diaries.keys.sort.reverse_each do |date|
          next unless m.diaries[date].visible?
          m.diaries[date].to_src.scan(%r{(?:isbn(?:_detail|_image|_image_left|_image_right|Img|ImgLeft|ImgRight)?|amazon)\s*\(?\s*["'](\w+)["']}).reverse.each do |isbn|
            isbns.push(isbn)  unless isbns.include?(isbn)
            throw :exit if items <= isbns.size
          end
        end
      end
    end
  }

  result = %Q|<div class="recent-amazon flex items-center content-between justify-between flex-wrap">\n|
  isbns.each do |isbn|
    if hidename
      data = %Q|<li class="list-reset inline-block"><%=isbn_image "#{isbn[0]}"%></li>\n|
    else
      data = %Q|<li class="list-reset inline-block"><%=isbn_detail "#{isbn[0]}"%></li>\n|
    end
    result << data
  end
  result << "</div>"

  conf_backup = [ @conf['amazon.nodefault'], @conf['amazon.imgsize'], @conf['amazon.hidename'] ]
  @conf['amazon.nodefault'] = nodefault
  @conf['amazon.imgsize'] = imgsize
  @conf['amazon.hidename'] =  hidename
  result = apply_plugin( result )
  @conf['amazon.nodefault'], @conf['amazon.imgsize'], @conf['amazon.hidename'] = conf_backup

  result = result.gsub(/layout="responsive"/,'layout="fixed"')
  File.open(cache, File::WRONLY | File::CREAT) do | file |
    file.flock(File::LOCK_EX)
    file.truncate(0)
    file.rewind
    file << result
  end
  result
end

def recent_amazon2(items = 'OBSOLUTE', imgsize = 'OBSOLUTE', hidename = 'OBSOLUTE', nodefault = 'OBSOLUTE')
  recent_amazon2_init
  cache = @conf['recent_amazon2.cache']
  result = ''
  begin
    File.open( cache, "r" ) do | file |
      file.flock(File::LOCK_SH)
      result = file.read();
    end
  rescue Errno::ENOENT
    result = recent_amazon2_generate_html
  end
  result
end

# unless @conf.secure then
  add_conf_proc( 'recent_amazon2', '最近の Amazon リンク' ) do
    recent_amazon2_conf_proc
  end

  add_update_proc do
    if @mode == 'append' || @mode == 'replace'
      recent_amazon2_generate_html
    end
  end
# end

def recent_amazon2_conf_proc
  result = ''

  if @mode == 'saveconf' then
    # unless @conf.secure then
      @conf['recent_amazon2.items'] = @cgi.params['recent_amazon2.items'][0].to_i
      @conf['recent_amazon2.imgsize'] = @cgi.params['recent_amazon2.imgsize'][0].to_i
      @conf['recent_amazon2.hidename'] = 'true'.casecmp(@cgi.params['recent_amazon2.hidename'][0]) == 0 ? true : false
      @conf['recent_amazon2.nodefault'] = 'true'.casecmp(@cgi.params['recent_amazon2.nodefault'][0]) == 0 ? true : false
      recent_amazon2_generate_html
    # end
  end
  recent_amazon2_init

  unless @conf.secure then
    result << <<-HTML_SRC
    <h3>何個分の商品を表示するか</h3>
    <p><input type="text" name="recent_amazon2.items" value="#{@conf['recent_amazon2.items']}"></p>
    <h3>表示するイメージのサイズ</h3>
    <p><select name="recent_amazon2.imgsize">
    <option value="0"#{if @conf['recent_amazon2.imgsize'] == 0 then " selected" end}>大きい</option>
    <option value="1"#{if @conf['recent_amazon2.imgsize'] == 1 then " selected" end}>普通</option>
    <option value="2"#{if @conf['recent_amazon2.imgsize'] == 2 then " selected" end}>小さい</option>
    </select></p>
    <h3>商品名を表示しない</h3>
    <p><select name="recent_amazon2.hidename">
    <option value="true"#{if @conf['recent_amazon2.hidename'] then " selected" end}>はい</option>
    <option value="false"#{if !@conf['recent_amazon2.hidename'] then " selected" end}>いいえ</option>
    </select></p>
    <h3>イメージが見付からない時に商品名のみ表示</h3>
    <p><select name="recent_amazon2.nodefault">
    <option value="true"#{if @conf['recent_amazon2.nodefault'] then " selected" end}>はい</option>
    <option value="false"#{if !@conf['recent_amazon2.nodefault'] then " selected" end}>いいえ</option>
    </select></p>
    HTML_SRC
  end
  result
end
