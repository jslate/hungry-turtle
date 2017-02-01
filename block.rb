class Block

  attr_accessor :angle

  SIZE = 6

  def initialize(window, x, y)
    @angle = rand(360)
    @speed = rand(3)
    @window = window
    @x = x
    @y = y
    @color = Gosu::Color.rgb(177,98,50)
  end

  def move
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height
  end

  def draw
    @window.draw_quad(@x, @y, @color,
      @x + SIZE, @y, @color,
      @x, @y + SIZE, @color,
      @x + SIZE, @y + SIZE, @color,
    ZOrder::BLOCK)
  end

  def collides?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

  def is_near?(x, y)
    ((@x - x).abs + (@y - y).abs) < 220
  end

end
