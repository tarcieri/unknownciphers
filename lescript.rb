#!/usr/bin/env ruby

require 'RMagick'
include Magick

CANVAS = Image.new(1493,5000) { self.background_color = "transparent" }

def composite(filename, options = {})
  image = ImageList.new
  image.from_blob File.read(filename)
  
  opts = {
    :width => image.columns,
    :height => image.rows,
    :x => 0,
    :y => 0
  }.merge(options)      
  
  image.thumbnail! opts[:width], opts[:height]
  begin
    CANVAS.composite! image, opts[:x], opts[:y], OverCompositeOp
  ensure
    image.destroy!
  end
end

slides = 1.upto(256).map { |n| "slides/slides#{sprintf("%03d", n)}.png" }
slides.each_with_index do |slide, n|
  p n
  composite(slide, y: n * 10)
end

CANVAS.format = "PNG"
File.write("unknownciphers.png", CANVAS.to_blob)
