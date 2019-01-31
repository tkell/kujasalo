require 'RMagick'
include Magick


# These constants will actually Do The Art
FILL_OPACITY = 0 
STROKE_OPACITY = 0.75
LINE_WIDTH = 6

f = Image.new(100,100) { self.background_color = "white" }
canvas = Magick::ImageList.new
canvas.new_image(250, 250) {self.background_color = "white"}

def draw_line(start_x, start_y, end_x, end_y, color)
  line = Magick::Draw.new
  line.fill_opacity(FILL_OPACITY)
  line.stroke_opacity(STROKE_OPACITY)
  line.stroke_width(LINE_WIDTH)
  line.stroke(color)
  line.polyline(start_x, start_y, end_x, end_y)
  return line
end

def draw_x(canvas, start_x, start_y, size, color_one, color_two)
  draw_line(start_x, start_y, start_x + size, start_y + size, color_one).draw(canvas)
  draw_line(start_x + size, start_y, start_x, start_y + size, color_two).draw(canvas)
end


draw_x(canvas, 0,0, 50, 'red', 'tomato')
draw_x(canvas, 50,0, 50, 'tomato', 'gold')
draw_x(canvas, 100,0, 50, 'red', 'tomato')
draw_x(canvas, 150,0, 50, 'tomato', 'gold')
draw_x(canvas, 200,0, 50, 'red', 'tomato')

draw_x(canvas, 0,50, 50, 'tomato', 'gold')
draw_x(canvas, 50,50, 50, 'red', 'tomato')
draw_x(canvas, 100,50, 50, 'tomato', 'gold')
draw_x(canvas, 150,50, 50, 'red', 'tomato')
draw_x(canvas, 200,50, 50, 'red', 'tomato')

canvas.write("output/test.jpg")
