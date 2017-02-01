require 'gosu'
require './player'
require './block'
require './game_window'

module ZOrder
  BACKGROUND, BLOCK, PLAYER, BEN, TEXT = *0..4
end

window = GameWindow.new
window.show
