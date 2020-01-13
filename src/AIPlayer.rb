class AIPlayer


	# BASIC PRINCIPLES:
	# in order to speed up learning process and conserve memory, isomorphic boards (boards that can be created by rotating or reflecting other boards) are considered to be the same board
	# each board represents 8 actual boards (possibly identical): 4 by rotations (0~3 rotations) and each of them can be reflected or not (x2)
	# if a new board state is presented and no other hash in memory matches any of the 8 isomorphic versions, that board is chosen as a representative for entire group
	# isomorphic versions are calculated by brute force each time a board is passed, since the process is fast enough not to require optimization (at the moment)
	#
	# learning process:
	# each board state has 1~9 possible moves
	# initially all moves are marked as "winning"
	# whenever a move directly leads to a loss, the move is marked as losing (directly = last move before oponnent makes a winning move)
	# whenever a move directly leads to a draw, the move is marked as drawing, unless it's already marked as losing
	# if after marking of move there are no more winning moves for a specific board state, the move that led to this board state is marked as 'drawing' (recursively)
	# if there are also no more drawing moves for board state above, the move that led to this board state is marked as 'losing' instead (recursively)

	@@rotate_counterclockwise = {
		0 => 6, 1 => 3, 2 => 0,
		3 => 7, 4 => 4, 5 => 1,
		6 => 8, 7 => 5, 8 => 2}

	@@rotate_clockwise = {
		0 => 2, 1 => 5, 2 => 8,
		3 => 1, 4 => 4, 5 => 7,
		6 => 0, 7 => 3, 8 => 6}

	# left <-> right mirror reflection
	@@reflect = {
		0 => 2, 1 => 1, 2 => 0,
		3 => 5, 4 => 4, 5 => 3,
		6 => 8, 7 => 7, 8 => 6}

	attr_reader :name
	# input: name: string, rng: Random)
	def initialize(name, rng = Random.new)
		@rng = rng
		@name = name
		@winning_moves = Hash.new # hash map: key = hash of current board, value = list of moves that are considered winning (integers 0~8)
		@drawing_moves = Hash.new # hash map: key = hash of current board, value = list of moves that are considered drawing (integers 0~8)
		@losing_moves = Hash.new # hash map: key = hash of current board, value = list of moves that are considered losing (integers 0~8)

		# @games_move_history[1] = history of moves in games where this instance is player 1
		# @games_move_history[2] = history of moves in games where this instance is player 2
		# hash map: key = game_id, value = list of consecutive moves (Move_History_Entry)
		@games_move_history = [nil, Hash.new, Hash.new]
	end

	# if victorious, don't change behaviour
	# remove the game from history
	# board argument is used by real player class
	# input: board: (not used), game_id: int, num: int (1..2)
	def declare_victorious(board, game_id, num)
		@games_move_history[num].delete(game_id)
	end

	# if drawed, set last move as "drawing"
	# remove the game from history
	# board argument is used by real player class
	# # input: board: (not used), game_id: int, num: int (1..2)
	def declare_draw(board, game_id, num)
		mark_last_move_as_drawing(game_id, num)
		@games_move_history[num].delete(game_id)
	end

	# if defeated, set last move as "losing"
	# remove the game from history
	# board argument is used by real player class
	# # input: board: (not used), game_id: int, num: int (1..2)
	def declare_defeated(board, game_id, num)
		mark_last_move_as_losing(game_id, num)
		@games_move_history[num].delete(game_id)
	end

	# find last move taken in a game as a player of specific number and move it to list of losing moves
	# if there are no more winning moves, but drawing moves exist, move previous move to 'drawing' list
	# if there are no more winning or drawing moves, move previous move to 'losing' list
	# recursive
	#
	# refactor - method extraction required
	# # input: game_id: int, num: int (1..2)
	def mark_last_move_as_losing(game_id, player_number)
		if @games_move_history[player_number][game_id].length > 0
			last_move = @games_move_history[player_number][game_id].pop
			if @winning_moves[last_move.board_hash].include?(last_move.move)
				move_winning_to_losing(game_id, last_move, player_number)
			elsif @drawing_moves[last_move.board_hash].include?(last_move.move)
				move_drawing_to_losing(game_id, last_move, player_number)
			end
		end
	end

	# find last move taken in a game as a player of specific number and move it to list of drawing moves, unless it's a losing move
	# if there are no more winning moves, move previous move to 'drawing' list
	# recursive
	#
	# refactor - method extraction required
	# # input: game_id: int, num: int (1..2)
	def mark_last_move_as_drawing(game_id, player_number)
		if @games_move_history[player_number][game_id].length > 0
			last_move = @games_move_history[player_number][game_id].pop
			if @winning_moves[last_move.board_hash].include?(last_move.move)
				move_winning_to_drawing(game_id, last_move, player_number)
			end
		end
	end

	# if it's a new game, create empty queue of moves
	# find a (potentially already existing) isomorphic board hash (Board_Info object)
	# find a move
	# add move with board hash to the history
	# return move converted into a move on the actual board by reverting rotation and reflection of Board_Info object
	# # input: board: Board, game_id: int, num: int (1..2)
	def take_a_turn(board, game_id, player_number)
		if !(@games_move_history[player_number].has_key? game_id)
			new_move_queue = Array.new
			@games_move_history[player_number][game_id] = new_move_queue
		end
		board_array = board.to_a
		board_info = get_board_info_with_hash(board_array)
		move = find_move(board_info.board_hash, board_info.array)
		@games_move_history[player_number][game_id].push MoveHistoryEntry.new(move, board_info.board_hash)
		AIPlayer.convert(move, board_info.rotation, board_info.reflection)
	end


	# provided array is rotated and reflected for a total of 8 isomorphic boards
	# each version's hash is calculated
	# if any of the hashes already has a list of moves mapped to it, that board's info object is returned
	# otherwise original board's object is returned (first)
	# input: board_array: Array (size: 9, possible values: 'X', 'O', nil)
	# output: Board_Info
	def get_board_info_with_hash(board_array)
		board_info_list = Array.new
		(0..3).each do |rotation|
			board_info_list.push(AIPlayer.calculate_board_hash(board_array, rotation, false))
			board_info_list.push(AIPlayer.calculate_board_hash(board_array, rotation, true))
		end
		result = board_info_list.find { |board_info| @winning_moves.has_key?(board_info.board_hash) || @drawing_moves.has_key?(board_info.board_hash) || @losing_moves.has_key?(board_info.board_hash) }
		if result.nil?
			result = board_info_list.first
		end
		result
	end

	# board_hash is a hash that corresponds to array provided as a second argument
	#
	# hash could be calculated from array, but since it has been calculated earlier, there's no need to repeat the calculation
	# unless for a purpose of cleaning the code
	#
	# searches for list of winning moves mapped to provided board hash
	# if no winning moves found, searches for drawing moves
	# if no drawing moves found, searches for losing moves
	# if board hash doesn't have list of moves mapped to it, the list of winning moves is created from valid moves on array
	# 		and lists of drawing and losing moves are empty
	#
	# after first list of moves is found/created, a move is chosen at random
	# input: board_hash: int, array: Array(size: 9, possible values: 'X', 'O', nil)
	# output: int (0..8)
	def find_move(board_hash, array)
		if @winning_moves.has_key?(board_hash) && @winning_moves[board_hash].any?
			#puts "found winning moves"
			list_of_moves = @winning_moves[board_hash]
		elsif @drawing_moves.has_key?(board_hash) && @drawing_moves[board_hash].any?
			#puts "found drawing moves"
			list_of_moves = @drawing_moves[board_hash]
		elsif @losing_moves.has_key?(board_hash) && @losing_moves[board_hash].any?
			#puts "found losing moves"
			list_of_moves = @losing_moves[board_hash]
		else
			list_of_moves = (0..8).to_a.select { |move| array[move].nil? }
			@winning_moves[board_hash] = list_of_moves
			@drawing_moves[board_hash] = Array.new
			@losing_moves[board_hash] = Array.new
			#puts "found no moves, creating new list: #{list_of_moves.to_s}"
		end
		list_of_moves[@rng.rand(list_of_moves.length)]
	end

	# move = integer
	# undoes rotation and reflection applied to the board_array when searching for existing board hash
	# input: move: int (0..8), rotation: int (0..3), reflection: true/false
	# output: int (0..8)
	def self.convert(move, rotation, reflection)
		converted_move = AIPlayer.unrotate(move, rotation)
		if reflection
			converted_move = @@reflect[converted_move]
		end
		converted_move
	end

	# move = integer
	# returns value that selected move would have if a board was rotated counterclockwise
	# recursive
	# 	# input: move: int (0..8), rotation: int (0..3)
	# 	# output: int (0..8)
	def self.unrotate(move, rotation)
		if rotation == 0
			move
		else
			AIPlayer.unrotate(@@rotate_counterclockwise[move], rotation - 1)
		end
	end

	# board_array = array of size 9
	# rotation = integer 0~3
	# reflection = true/false
	# each board space has a value of consecutive prime
	# if space is 'X', hash is multiplied by assigned prime
	# if space is 'O', hash is multiplied by square of assigned prime
	# each unique board state should have unique hash
	# no integer overflow detected
	# returns Board_Info object that contains hash, rotation and reflection that lead to this isomorphic version of board, and resulting board array
	# 	# input: board_array: Array (size: 9, possible values: 'X', 'O', nil), rotation: int (0..3), reflection: true/false
	# 	# output: Board_Info
	def self.calculate_board_hash(board_array, rotation, reflection)
		if reflection
			array = AIPlayer.reflect(board_array)
		else
			array = board_array
		end
		array = AIPlayer.rotate_clockwise(array, rotation)
		primes = [2, 3, 5, 7, 11, 13, 17, 19, 23]
		board_hash = 1
		(0..8).each do |position|
			case array[position]
			when 'X'
				board_hash = board_hash * primes[position]
			when 'O'
				board_hash = board_hash * primes[position] * primes[position]
			else
				nil
			end
		end
		Board_Info.new(board_hash, rotation, reflection, array)
	end

	# reflects board left <-> right
	# input: board_array: Array (size: 9, possible values: 'X', 'O', nil)
	# output: int (0..8)
	def self.reflect(arg_array)
		array = arg_array.map(&:clone)
		array[0], array[2] = array[2], array[0]
		array[3], array[5] = array[5], array[3]
		array[6], array[8] = array[8], array[6]
		array
	end

	# recursive
	# input: board_array: Array (size: 9, possible values: 'X', 'O', nil), rotation: int (0..3)
	# output: int (0..8)
	def self.rotate_clockwise(array, rotation = 0)
		if rotation == 0
			array
		else
			rotated_array = [array[6], array[3], array[0],
							 array[7], array[4], array[1],
							 array[8], array[5], array[2]]
			AIPlayer.rotate_clockwise(rotated_array, rotation - 1)
		end
	end

	private

	def move_winning_to_drawing(game_id, last_move, player_number)
		@winning_moves[last_move.board_hash].delete(last_move.move)
		@drawing_moves[last_move.board_hash].push(last_move.move)
		if @winning_moves[last_move.board_hash].empty?
			mark_last_move_as_drawing(game_id, player_number)
		end
	end

	def move_drawing_to_losing(game_id, last_move, player_number)
		@drawing_moves[last_move.board_hash].delete(last_move.move)
		@losing_moves[last_move.board_hash].push(last_move.move)

		if @drawing_moves[last_move.board_hash].empty?
			#puts "no more winning or drawing moves, changing previous move to losing"
			mark_last_move_as_losing(game_id, player_number)
		end
	end

	def move_winning_to_losing(game_id, last_move, player_number)
		@winning_moves[last_move.board_hash].delete(last_move.move)
		@losing_moves[last_move.board_hash].push(last_move.move)
		if @winning_moves[last_move.board_hash].empty?
			if @drawing_moves[last_move.board_hash].empty?
				#puts "no more winning or drawing moves, changing previous move to losing"
				mark_last_move_as_losing(game_id, player_number)
			else
				#puts "no more winning moves, changing previous move to drawing"
				mark_last_move_as_drawing(game_id, player_number)
			end
		end
	end
end

# contains array and its hash, as well as rotation and reflection required to get that array from one representing actual game state
class Board_Info

	# input: board_hash: int, rotation: int (0..3), reflection true/false, array: Array (size: 9, possible values: 'X', 'O', nil)
	def initialize(board_hash, rotation, reflection, array)
		@board_hash = board_hash
		@rotation = rotation
		@reflection = reflection
		@array = array
	end

	def board_hash
		@board_hash
	end

	def rotation
		@rotation
	end

	def reflection
		@reflection
	end

	def array
		@array
	end
end

# contains move chosen by ai and hash of a specific isomorphic version of actual board state
class MoveHistoryEntry

	#input: move: int (0..8), board_hash: int
	def initialize(move, board_hash)
		@board_hash = board_hash
		@move = move
	end

	def board_hash
		@board_hash
	end

	def move
		@move
	end

end