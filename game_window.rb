class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  RED = Gosu::Color::RED
  YELLOW = Gosu::Color::YELLOW
  BLOCK_COUNT = 5

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Simple Gosu"
    @background_image = Gosu::Image.new(self, "media/water.png", true)
    @player = Player.new(self)
    @blocks = 1.upto(BLOCK_COUNT).to_a.map { |_i| Block.new(self, rand(WIDTH), rand(HEIGHT)) }
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
