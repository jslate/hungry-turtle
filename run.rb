require 'gosu'

WIDTH = 720
HEIGHT = 480

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
    1)
  end

  def is_near?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

end

class Player

  attr_accessor :angle
  attr_reader :x, :y

  def initialize(window)
    @window = window
    @ship = Gosu::Image.new(window, "media/turtle.png", false)
    @angle = 90
    @x = 300
    @y = 300
  end

  def move
    @x += Gosu::offset_x(@angle, 1)
    @y += Gosu::offset_y(@angle, 1)
    @x %= @window.width
    @y %= @window.height
  end

  def turn(direction)
    @angle += (direction == :clockwise ? 1 : -1)
  end

  def draw
    @ship.draw_rot(@x, @y, 2, @angle)
  end

end


class GameWindow < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Simple Gosu"
    @background_image = Gosu::Image.new(self, "media/water.png", true)
    @player = Player.new(self)
    @blocks = 1.upto(100).to_a.map { |_i| Block.new(self, rand(WIDTH), rand(HEIGHT)) }
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn(:counterclockwise)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn(:clockwise)
    end
    move
  end

  def move
    @player.move
    @blocks.reject!{|block| block.is_near?(@player.x, @player.y)}
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    @blocks.each(&:draw)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
