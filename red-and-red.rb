require 'RMagick'
include Magick

# 9 totally unchanging diangonal rows
# 7 rows of transition 
# 9 totally unchanging horizontal rows


# These constants will actually Do The Art
FILL_OPACITY = 0 
STROKE_OPACITY = 0.75
LINE_WIDTH = 6
COLOR_ONE = 'red'
COLOR_TWO = 'tomato'
COLOR_THREE = 'gold'
COLOR_FOUR = 'dark red' # !!

canvas = Magick::ImageList.new
canvas.new_image(450, 1250) {self.background_color = "white"}

def draw_line(start_x, start_y, end_x, end_y, color)
  line = Magick::Draw.new
  line.fill_opacity(FILL_OPACITY)
  line.stroke_opacity(STROKE_OPACITY)
  line.stroke_width(LINE_WIDTH)
  line.stroke(color)
  line.polyline(start_x, start_y, end_x, end_y)
  return line
end

# So our subtraction is about 1/3 of LINE_WIDTH, and about 1/20 of the size of the X
def draw_x(canvas, start_x, start_y, size, color_one, color_two)
  draw_line(start_x + 2, start_y + 2, start_x + size - 2, start_y + size - 2, color_one).draw(canvas)
  draw_line(start_x + size - 2, start_y + 2, start_x + 2, start_y + size - 2, color_two).draw(canvas)
end

def draw_cross(canvas, start_x, start_y, size, color_one, color_two)
  draw_line(start_x, start_y + (size / 2), start_x + size, start_y + (size / 2), color_one).draw(canvas)
  draw_line(start_x + (size / 2), start_y, start_x + (size / 2), start_y + size, color_two).draw(canvas)
end

def draw_row_with_x(canvas, size, row, row_offset)
  if row % 2 == 0
    line_array = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
  else
    line_array = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
  end

  y_offset = size * (row + row_offset)
  line_array.each_with_index do |item, index|
    x_offset = index * size
    if item == 0
      color_one = 'red'
      color_two = 'tomato'
    end
    if item == 1
      color_one = 'tomato'
      color_two = 'gold'
    end
    draw_x(canvas, x_offset,y_offset, size, color_one, color_two)
  end
end


def draw_row_with_cross(canvas, size, row, row_offset)
  if row % 2 == 0
    line_array = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
  else
    line_array = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
  end

  y_offset = size * (row + row_offset)
  line_array.each_with_index do |item, index|
    x_offset = index * size
    if item == 0
      color_one = 'red'
      color_two = 'tomato'
    end
    if item == 1
      color_one = 'tomato'
      color_two = 'gold'
    end
    draw_cross(canvas, x_offset,y_offset, size, color_one, color_two)
  end
end

for row in 0..8 do
  draw_row_with_x(canvas, 50, row, 0)
end

for row in 0..8 do
  draw_row_with_cross(canvas, 50, row, 16)
end

canvas.write("output/test.jpg")
