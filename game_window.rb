class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  RED = Gosu::Color::RED
  YELLOW = Gosu::Color::YELLOW
  BLOCK_COUNT = 5

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Hungry Turtle"
    @sound = Gosu::Sample.new('media/crunch.au')
    @background_image = Gosu::Image.new(self, "media/water.png", true)
    @ben = Gosu::Image.new(self, "media/ben.png", true)
    @player = Player.new(self)
    add_blocks(BLOCK_COUNT)
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
    @blocks.reject!{|block| consume?(block)}
    add_blocks(1) if @ticks % 600 == 0 && !won?
    @blocks.each(&:move)
    change_color if @ticks % 5 == 0
  end

  def add_blocks(number = 1)
    @blocks ||= []
    @blocks += 1.upto(number).to_a.map { |_i| Block.new(self, rand(WIDTH), rand(HEIGHT)) }
  end

  def consume?(block)
    if block.collides?(@player.x, @player.y)
      @player.speed += 1
      @sound.play
      true
    else
      if block.is_near?(@player.x, @player.y)
        block.angle = @player.angle
      end
      false
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @player.draw
    @blocks.each(&:draw)
    you_win if won?
  end

  def change_color
    @text_color = @text_color == RED ? YELLOW : RED
  end

  def won?
    @blocks.empty?
  end

  def you_win
    @ben.draw_rot(200, 200, ZOrder::BEN, @ticks % 360)
    @player.turn(:clockwise)
    args = width/2 - 100,height/2 - 100, ZOrder::TEXT, 1, 1, @text_color
    Gosu::Image.from_text(self, 'YOU WIN!', Gosu.default_font_name, 45).draw(*args) if won?
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end
end
