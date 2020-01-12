class Player

	# this class is responsible for displaying board state and recieving+parsing human player moves
	# communication by standard input and standard output

	attr_reader :name
	def initialize(name)
		@name = name
	end

	# game_id and num are used by AIPlayer
	# input: board: Board, game_id: (not used), num: (not used)
	# output: int (not used)
	def declare_victorious(board, game_id, num)
		puts "#{@name} won\n"
		display(board)
		gets
	end

	# game_id and num are used by AIPlayer
	# # input: board: Board, game_id: (not used), num: (not used)
	# # output: int (not used)
	def declare_defeated(board, game_id, num)
		puts "#{@name} lost\n"
		display(board)
		gets
	end

	# game_id and num are used by AIPlayer
	# input: board: Board, game_id: (not used), num: (not used)
	# output: int (not used)
	def declare_draw(board, game_id, num)
		puts "#{@name} drawed\n"
		display(board)
		gets
	end

	# game_id and num are used by AIPlayer
	# displays board, then takes input (integer) until it is recognized as a valid move on the board
	# input: board: Board, game_id: (not used), num: (not used)
	# output: int (validated by board)
	def take_a_turn(board, game_id, num)
		# Gem.win_platform? ? (system "cls") : (system "clear")
		puts "Your turn #{@name}\n"
		display(board)
		input = get_input.to_i
		loop do
			break if board.legal_move?(input)
			display(board)
			input = get_input.to_i
		end
		input
	end

	# board.to_s
	def display(board)
		puts board
	end

	# takes input and converts to integer
	# only leading digits are taken into account
	# if string starts with anything other than a digit, to_i returns 0.
	# "13a" -> 13
	# "1a3" -> 1
	# "a13" -> 0
	# output: int
	def get_input
		input = gets
		input.to_i
	end
end
