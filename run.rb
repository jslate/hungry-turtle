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
    @image = Gosu::Image.new(window, "media/turtle.png", false)
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
    @image.draw_rot(@x, @y, 2, @angle)
  end

end


class GameWindow < Gosu::Window

  RED = Gosu::Color::RED
  YELLOW = Gosu::Color::YELLOW

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Simple Gosu"
    @background_image = Gosu::Image.new(self, "media/water.png", true)
    @player = Player.new(self)
    @blocks = 1.upto(15).to_a.map { |_i| Block.new(self, rand(WIDTH), rand(HEIGHT)) }
    @ticks = 0
    @text_color = RED
  end

  def update
    @ticks += 1
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn(:counterclockwise)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn(:clockwise)
    end
    move
    change_color if @ticks % 5 == 0
  end

  def change_color
    @text_color = @text_color == RED ? YELLOW : RED
  end

  def move
    @player.move
    @blocks.reject!{|block| block.is_near?(@player.x, @player.y)}
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    @blocks.each(&:draw)
    you_win if @blocks.empty?
  end

  def you_win
    @player.turn(:clockwise)
    args = width/2 - 100,height/2 - 100, 1, 1, 3, @text_color
    Gosu::Image.from_text(self, 'YOU WIN!', Gosu.default_font_name, 45).draw(*args) if @blocks.empty?
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
