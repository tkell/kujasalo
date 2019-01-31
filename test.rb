require 'RMagick'
include Magick

f = Image.new(100,100) { self.background_color = "white" }

canvas = Magick::ImageList.new
canvas.new_image(250, 250) {self.background_color = "white"}

line_one = Magick::Draw.new
line_one.stroke('tomato')
line_one.fill_opacity(0)
line_one.stroke_opacity(0.75)
line_one.stroke_width(6)
line_one.polyline(0,0, 50,50)
line_one.draw(canvas)

canvas.write("output/test.jpg")
