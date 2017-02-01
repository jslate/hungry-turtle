class Block

  SIZE = 6

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @color = Gosu::Color.rgb(177,98,50)
  end

  def draw
    @window.draw_quad(@x, @y, @color,
      @x + SIZE, @y, @color,
      @x, @y + SIZE, @color,
      @x + SIZE, @y + SIZE, @color,
    ZOrder::BLOCK)
  end

  def is_near?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

end
