require 'gosu'
require './player'
require './block'
require './game_window'

module ZOrder
  BACKGROUND, BLOCK, PLAYER, TEXT = *0..3
end

window = GameWindow.new
window.show
