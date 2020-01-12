require_relative 'Board'
require_relative 'Player'
require_relative 'AIPlayer'
require_relative 'RandomPlayer'
require_relative 'Game'
require_relative 'FakeRandom'


@@you = Player.new "you"
@@ai = AIPlayer.new('AI', Random.new)
@@random = RandomPlayer.new('random')

class Menu
	def initialize()
		@choices = nil
		@values = nil
		@num_choices = nil
		@num_games = 0
		@players = [@@you, @@ai, @@random]
	end

	def set_choices(choices)
		@choices = choices
		@num_choices = choices.length
	end
	
	def set_values(values)
		@values = values
	end
	
	def set_num_games()
		puts "how many games?"
		input = gets
		@num_games = input.to_i - 1
	end

	def menu_loop
		while true
			Gem.win_platform? ? (system "cls") : (system "clear")
			display
			input = gets
			index = input.to_i
			self.method(@values[index]).call
		end
	end

	def display
		@num_choices.times do |i|
			print "[#{i}] #{@choices[i]}\n"
		end
	end

	def start_the_game
		Gem.win_platform? ? (system "cls") : (system "clear")
		display_players
		puts "player X: "
		input = gets
		index = input.to_i
		usr_1 = @players[index]
		puts "player O: "
		input = gets
		index = input.to_i
		usr_2 = @players[index]

		(0..@num_games).each do |a|
			b = Board.new
			g = Game.new(usr_1, usr_2, b)
			g.start
		end		
		return
	end

	def give_details_str
		puts "Give us the name:"
		input = gets
		return input.to_s
	end
		
	def add_player
		name = give_details_str
		while true
			puts "Press 0/1 if you want the player to be human/AI"
			choice = gets
			ch = choice.to_i
			if ch == 0
				user = Player.new name
				@players << user
				return
			elsif ch == 1
				user = AIPlayer.new(name, Random.new)
				@players << user
				return
			end
		end
	end 

	def display_players
		puts "---------\navailable players:\n----------"
		amount = @players.length
		amount.times do |i|
			if i % 2 == 0
				print "[#{i}] #{@players[i].name}     "
			elsif
				print "[#{i}] #{@players[i].name}\n"
			end
		end
		puts "\n"
	end

	def own_exit
		exit
	end
end

# p2 = Player.new "p2"
# ai2 = AIPlayer.new('ai2', Random.new)
# random = RandomPlayer.new('random')
# def start
# 	choices = ["new game", "add player", "quit"]
# 	values = [start_the_game, self.add_player, exit]
# 	menu = Menu.new(choices, values)
# 	return menu.menu_loop
# end

menu = Menu.new()
menu.set_choices(["new game", "new player", "change number of games to play", "quit"])
menu.set_values([:start_the_game, :add_player, :set_num_games, :own_exit])
menu.menu_loop
