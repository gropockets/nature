#!/usr/bin/env ruby

require 'padrino-helpers'

def setname2(dir, name, size, ext)
	puts  "/assets/images/" + dir + "/sets/" + name + "-" + size + ext
end

def setname(src, size)
	ext = File.extname(src)
	dir = File.dirname(src)
	name = File.basename(src, ext)
	"/assets/images/" + dir + "/sets/" + name + "-" + size + ext
end

def setexists?(src)
	sitemap.find_resource_by_path(setname(src, "1x"))
end

def pic_tag(src)
	tag = "<picture>"
	tag << %Q^\n\t<source srcset="#{setname(src, "3x")}" media="(min-width: 1200px)">^ 
	tag << %Q^\n\t<source srcset="#{setname(src, "2x")}" media="(min-width: 600px)">^
	tag << %Q^\n\t<img src="#{setname(src, "1x")}" alt="This picture loads on non-supporting browsers.">^
	tag << "\n</picture>"
end

src = "AfricanBlackSoap/african-blacksoap-groupshot.jpg"
src_ext = File.extname(src)
src_dir = File.dirname(src)
src_filebase = File.basename(src, src_ext)

setname(src, "1x")
puts pic_tag(src)
puts tag(:br, :style => 'clear:both') # => <br style="clear:both" />
