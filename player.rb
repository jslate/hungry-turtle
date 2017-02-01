class Player

  SPEED = 1

  attr_accessor :angle
  attr_reader :x, :y

  def initialize(window)
    @window = window
    @image = Gosu::Image.new(window, "media/turtle.png", false)
    @angle = 90
    @x = 300
    @y = 300
  end

  def move
    @x += Gosu::offset_x(@angle, SPEED)
    @y += Gosu::offset_y(@angle, SPEED)
    @x %= @window.width
    @y %= @window.height
  end

  def turn(direction)
    @angle += (direction == :clockwise ? 1 : -1)
  end

  def draw
    @image.draw_rot(@x, @y, 2, @angle)
  end

end
