require_relative 'Board'
class Game
	@@id = 0

	def initialize(player_1, player_2, board = Board.new)
		@id = @@id
		@@id = @@id + 1
		@board = board
		@player_1 = player_1
		@player_2 = player_2
		@game_over = false
		@winner = nil
	end

	def start
		if @game_over
			raise Exception.new("GAME #{@id} IS ALREADY OVER")
		end
		puts "starting game #{@id}\n"
		loop do
			break if @game_over
			player_move = player_turn @player_1, 1
			@game_over = resolve_move(player_move, 'X')
			break if @game_over
			player_move = player_turn @player_2, 2
			@game_over = resolve_move(player_move, 'O')
		end
		puts "game #{@id} is over, result: #{@winner}\n"
	end

	def resolve_move(player_move, token)
		@board.insert(player_move, token)
		check_victory_condition
	end

	def check_victory_condition
		@winner = @board.victory?
		#puts "status: #{result}\n"

		if @winner == 'X'
			@player_2.declare_defeated @board, @id, 2
			@player_1.declare_victorious @board, @id, 1
			true
		elsif @winner == 'O'
			@player_2.declare_victorious @board, @id, 2
			@player_1.declare_defeated @board, @id, 1
			true
		elsif @winner == 'DRAW'
			@player_2.declare_draw @board, @id, 2
			@player_1.declare_draw @board, @id, 1
			true
		else
			false
		end
	end

	def player_turn(player, num)
		player_move = nil
		loop do
			player_move = player.take_a_turn(@board, @id, num)
			break if @board.legal_move?(player_move)
		end
		player_move
	end
end
