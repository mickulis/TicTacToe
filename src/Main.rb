require_relative 'Board'
require_relative 'Player'
require_relative 'Game'


p1 = Player.new "p1"
p2 = Player.new "p2"
b = Board.new
g = Game.new b, p1, p2
g.start

