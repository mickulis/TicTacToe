require_relative 'Board'
class Game
	@@id = 0

	# @@id = global counter in case of multiple parallel games with the same AI
	def initialize(player_1, player_2, board = Board.new)
		@id = @@id
		@@id = @@id + 1
		@board = board
		@player_1 = player_1
		@player_2 = player_2
		@game_over = false
		@winner = nil
	end

	# asks each player for a valid input and passes it to board until a winner or draw is declared
	# if a game is already over, it cannot be restarted or resumed
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

	# pass player's move to the board and check if the game is over
	# input: player_move: int (0..8), token: string ('X' or 'O')
	# output: true/false
	def resolve_move(player_move, token)
		@board.insert(player_move, token)
		check_victory_condition
	end

	# if there is a winner, declare players as winner and loser, return true
	# if there is a draw, declare draw for both players, return true
	# if a game is undecided return false
	# output: true/false
	def check_victory_condition
		@winner = @board.victory?

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

	# ask player for a valid move until a valid move is provided
	# @id and player_number used only by AI
	#
	def player_turn(player, player_number)
		player_move = nil
		loop do
			player_move = player.take_a_turn(@board, @id, player_number)
			break if @board.legal_move?(player_move)
		end
		player_move
	end

	# output: nil, 'X', 'O', or 'DRAW'
	def winner?
		@winner
	end
end
