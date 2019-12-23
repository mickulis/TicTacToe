class Game
	def initialize(board, player_1, player_2)
		@board = board
		@player_1 = player_1
		@player_2 = player_2
	end

	def start
		puts "start\n"
		@game_over = false
		loop do
			player_move = player_turn @player_1
			game_over = resolve_move(player_move, 'X')
			break if game_over
			player_move = player_turn @player_2
			game_over = resolve_move(player_move, 'O')
			break if game_over
		end
	end

	def resolve_move(player_move, token)
		@board.insert(player_move, token)
		check_victory_condition
	end

	def check_victory_condition
		result = @board.victory?
		puts "status: #{result}\n"

		if result == 'X'
			@player_1.declare_victorious @board
			@player_2.declare_defeated @board
			true
		elsif result == 'O'
			@player_2.declare_victorious @board
			@player_1.declare_defeated @board
			true
		elsif result == 'DRAW'
			@player_1.declare_draw @board
			@player_2.declare_draw @board
			true
		else
			false
		end
	end

	def player_turn(player)
		player_move = nil
		loop do
			player_move = player.take_a_turn(@board)
			break if @board.legal_move?(player_move)
			puts "#{player_move} illegal\n"
		end
		player_move
	end
end
