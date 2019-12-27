require_relative 'Board'
require_relative 'Player'
require_relative 'AIPlayer'
require_relative 'RandomPlayer'
require_relative 'Game'
require_relative 'FakeRandom'


Gem.win_platform? ? (system "cls") : (system "clear")

p1 = Player.new "p1"
p2 = Player.new "p2"
ai1 = AIPlayer.new("ai1", Random.new)
ai2 = AIPlayer.new('ai2', Random.new)
random = RandomPlayer.new('random')

(0..10000).each do |a|
	b = Board.new
	g = Game.new(ai2, ai2, b)
	g.start
end

(0..10000).each do |a|
	b = Board.new
	g = Game.new(p1, ai2, b)
	g.start
end
