class Player

  attr_accessor :angle, :speed
  attr_reader :x, :y

  def initialize(window)
    @window = window
    @images = Gosu::Image::load_tiles("media/turtlefire.png", 60, 100)
    @angle = 90
    @x = 300
    @y = 300
    @speed = 1
  end

  def move
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height
  end

  def turn(direction)
    @angle += (direction == :clockwise ? 1 : -1)
  end

  def draw
    animations = get_animations
    img = animations[Gosu::milliseconds / 150  % animations.size]
    img.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
  end

  def get_animations
    case @speed
    when 1
      [@images[0]]
    when 2, 3
      [@images[0], @images[1]]
    when 4, 5
      [@images[1], @images[2]]
    else
      [@images[2], @images[3]]
    end

  end

end
