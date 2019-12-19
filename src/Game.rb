class Game
	def initialize(board, player_1, player_2)
		@board = board
		@player_1 = player_1
		@player_2 = player_2
	end

	def start
		game_over = false

		loop do
			player_move = @player_1.take_a_turn(board)
			break if @board.check(player_move)
		end
		@board.insert(player_move, 1)
		result = @board.victory?
		case
		when result == 1
			@player_1.declare_victorious
			@player_2.declare_defeated
			game_over = true
		end

		loop do
			player_move = @player_2.take_a_turn(board)
			break if @board.check(player_move)
		end
		@board.insert(player_move, -1)
		result = @board.victory?
		case
		when result == -1
			@player_1.declare_victorious
			@player_2.declare_defeated
			game_over = true
		end
	end


end
