require 'RMagick'
include Magick

# 7 totally unchanging diangonal rows
# 7 rows of transition 
# 7 totally unchanging horizontal rows
# 21 rows total
# if I did 7-7-7, that is 21 rows, which is 6.6 by 3 feet
# if each X is 4, that is 1200 dots per X, so SIZE = 1200, owww
# OR, Kujsalo's Xs are `783` dots, which would make the whole thing a bit smaller.

# These constants will actually Do The Art
FILL_OPACITY = 0 
STROKE_OPACITY = 0.9

SIZE = 1000
LINE_WIDTH = SIZE / 40
X_SPACE_OFFSET = SIZE / 30
EACH_ROTATION = SIZE / 16
WIDTH = SIZE * 9
HEIGHT = SIZE * 21

COLOR_ONE = '#fb5b05'
COLOR_TWO = '#fc7c37'
COLOR_THREE = '#FD2A4A'
COLOR_FOUR = '#ffcc66' 

canvas = Magick::ImageList.new
canvas.new_image(WIDTH, HEIGHT) {
  self.background_color = "white"
  self.density = 300
}

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
  draw_line(start_x + X_SPACE_OFFSET, start_y + X_SPACE_OFFSET,
            start_x + size - X_SPACE_OFFSET, start_y + size - X_SPACE_OFFSET, color_one
           ).draw(canvas)
  draw_line(start_x + size - X_SPACE_OFFSET, start_y + X_SPACE_OFFSET,
            start_x + X_SPACE_OFFSET, start_y + size - X_SPACE_OFFSET, color_two
           ).draw(canvas)
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
      draw_x_with_counterclockwise_rotation(canvas, x_offset,y_offset, size, color_one, color_two, rotation_offset)
    end
    if item == 1
      color_one = COLOR_THREE
      color_two = COLOR_FOUR
      draw_x_with_clockwise_rotation(canvas, x_offset,y_offset, size, color_one, color_two, rotation_offset)
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
for row in 0..6 do
  draw_row_with_x(canvas, SIZE, row, 0)
end

for row in 1...8 do
  rotation = EACH_ROTATION * row
  draw_row_with_rotation(canvas, SIZE, row - 1, 7, rotation)
end

for row in 0..6 do
  draw_row_with_cross(canvas, SIZE, row, 14)
end

canvas.write("output/test.jpg")
