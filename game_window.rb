class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  RED = Gosu::Color::RED
  YELLOW = Gosu::Color::YELLOW
  BLOCK_COUNT = 5

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Hungry Turtle"
    @background_image = Gosu::Image.new(self, "media/water.png", true)
    @player = Player.new(self)
    @blocks = 1.upto(BLOCK_COUNT).to_a.map { |_i| Block.new(self, rand(WIDTH), rand(HEIGHT)) }
    @ticks = 0
    @text_color = RED
    @song = Gosu::Song.new("media/song.m4a")
    @song.volume = 1
    @song.play(true)
  end

  def update
    @ticks += 1
    @player.turn(:counterclockwise) if [Gosu::KbLeft, Gosu::GpLeft].any?{ |k|button_down?(k) }
    @player.turn(:clockwise) if [Gosu::KbRight, Gosu::GpRight].any?{ |k|button_down?(k) }
    @player.move
    @blocks.reject!{|block| block.is_near?(@player.x, @player.y)}
    change_color if @ticks % 5 == 0
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @player.draw
    @blocks.each(&:draw)
    you_win if @blocks.empty?
  end

  def change_color
    @text_color = @text_color == RED ? YELLOW : RED
  end

  def you_win
    @player.turn(:clockwise)
    args = width/2 - 100,height/2 - 100, 1, 1, ZOrder::TEXT, @text_color
    Gosu::Image.from_text(self, 'YOU WIN!', Gosu.default_font_name, 45).draw(*args) if @blocks.empty?
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end
end
