require 'RMagick'
include Magick

# 9 totally unchanging diangonal rows
# 7 rows of transition 
# 9 totally unchanging horizontal rows

# These constants will actually Do The Art
FILL_OPACITY = 0 
STROKE_OPACITY = 0.66
LINE_WIDTH = 5
COLOR_ONE = '#fb9678'
COLOR_TWO = '#fdd0c2'
COLOR_THREE = '#fbd878'
COLOR_FOUR = '#f95c2e'

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

# So our subtraction is about 1/3 of LINE_WIDTH, and about 1/20 of the size
def draw_x(canvas, start_x, start_y, size, color_one, color_two)
  draw_line(start_x + 2, start_y + 2, start_x + size - 2, start_y + size - 2, color_one).draw(canvas)
  draw_line(start_x + size - 2, start_y + 2, start_x + 2, start_y + size - 2, color_two).draw(canvas)
end

def draw_x_with_counterclockwise_rotation(canvas, start_x, start_y, size, color_one, color_two, rotation_offset)
  draw_line(start_x,
            start_y + rotation_offset,
            start_x + size,
            start_y + size - rotation_offset,
            color_one).draw(canvas)

  draw_line(start_x + size - rotation_offset,
           start_y,
           start_x + rotation_offset,
           start_y + size,
           color_two).draw(canvas)
end

def draw_x_with_clockwise_rotation(canvas, start_x, start_y, size, color_one, color_two, rotation_offset)
  draw_line(start_x + rotation_offset,
            start_y,
            start_x + size - rotation_offset,
            start_y + size,
            color_one).draw(canvas)

  draw_line(start_x + size,
           start_y + rotation_offset,
           start_x,
           start_y + size - rotation_offset,
           color_two).draw(canvas)
end

def draw_cross(canvas, start_x, start_y, size, color_one, color_two)
  draw_line(start_x + (size / 2), start_y, start_x + (size / 2), start_y + size, color_two).draw(canvas)
  draw_line(start_x, start_y + (size / 2), start_x + size, start_y + (size / 2), color_one).draw(canvas)
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
      color_one = COLOR_ONE
      color_two = COLOR_TWO
    end
    if item == 1
      color_one = COLOR_THREE
      color_two = COLOR_FOUR
    end
    draw_x(canvas, x_offset,y_offset, size, color_one, color_two)
  end
end

def draw_row_with_rotation(canvas, size, row, row_offset, rotation_offset)
  if row % 2 == 0
    line_array = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
  else
    line_array = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
  end

  y_offset = size * (row + row_offset)
  line_array.each_with_index do |item, index|
    x_offset = index * size
    if item == 0
      color_one = COLOR_ONE
      color_two = COLOR_TWO
      draw_x_with_counterclockwise_rotation(canvas, x_offset,y_offset, 50, color_one, color_two, rotation_offset)
    end
    if item == 1
      color_one = COLOR_THREE
      color_two = COLOR_FOUR
      draw_x_with_clockwise_rotation(canvas, x_offset,y_offset, 50, color_one, color_two, rotation_offset)
    end
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
      color_one = COLOR_ONE
      color_two = COLOR_TWO
    end
    if item == 1
      color_one = COLOR_FOUR
      color_two = COLOR_THREE
    end
    draw_cross(canvas, x_offset,y_offset, size, color_one, color_two)
  end
end



## do it!
for row in 0..8 do
  draw_row_with_x(canvas, 50, row, 0)
end

draw_row_with_rotation(canvas, 50, 9, 0, 3.125)
draw_row_with_rotation(canvas, 50, 10, 0, 6.25)
draw_row_with_rotation(canvas, 50, 11, 0, 9.375)
draw_row_with_rotation(canvas, 50, 12, 0, 12.5)
draw_row_with_rotation(canvas, 50, 13, 0, 15.625)
draw_row_with_rotation(canvas, 50, 14, 0, 18.75)
draw_row_with_rotation(canvas, 50, 15, 0, 21.875)

for row in 0..8 do
  draw_row_with_cross(canvas, 50, row, 16)
end

canvas.write("output/test.jpg")
