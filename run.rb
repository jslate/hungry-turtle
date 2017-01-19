require 'gosu'

WIDTH = 720
HEIGHT = 480

class GameWindow < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Simple Gosu"
    @background_image = Gosu::Image.new(self, "media/space.png", true)
    @ship = Gosu::Image.new(self, "media/spaceship.png", false)
    @angle = 90
    @x = 300
    @y = 300
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @angle = 270
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @angle = 90
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @angle = 0
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @angle = 180
    end
    move
  end

  def move
    @x += Gosu::offset_x(@angle, 5)
    @y += Gosu::offset_y(@angle, 5)
    @x %= WIDTH
    @y %= HEIGHT
  end

  def draw
    @background_image.draw(0, 0, 0)
    @ship.draw_rot(@x, @y, 1, @angle)
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
