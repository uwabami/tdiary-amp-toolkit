#-*- mode: ruby;  coding:utf-8; -*-
#
# load MathJax
#
# Copyright(C) 2012 Youhei SASAKI, All rights reserved.
# $Lastupdate: 2017-01-25 08:16:35$
#
# Author: Youhei SASAKI <uwabami@gfd-dennou.org>
# License: MIT(Expat)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Code:
#
# Options:
mathjax_src = @options['mathjax_src'] || "http://cdn.mathjax.org/mathjax/latest/MathJax.js"
mathjax_config = @options['mathjax_config'] || "TeX-AMS_HTML"
mathjax_uri = "#{mathjax_src}?config=#{mathjax_config}"
x_mathjax_config = @options['x_mathjax_config'] ||
  %q{MathJax.Hub.Config({ tex2jax: { inlineMath: [['$','$']], displayMath: [['$$','$$']], processEscapes: true }});}

# Add footer
add_footer_proc do
  foot = "\n"
  if x_mathjax_config
    foot << %Q{\t<script type="text/x-mathjax-config">\n}
    foot << %Q{\t  #{x_mathjax_config}\n}
    foot << %Q{\t</script>\n}
  end
  foot << %Q{\t<script async="async" type="text/javascript" src="#{mathjax_uri}"></script>\n}
  foot
end

# Add 'tex' notation
def tex(src)
  %Q{  <p>\$#{src}\$</p>\n<p> }
end
