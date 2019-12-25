class Player

	@@unrotate = {
		0 => 6, 1 => 3, 2 => 0,
		3 => 7, 4 => 4, 5 => 1,
		6 => 8, 7 => 5, 8 => 2}

	@@unreflect = {
		0 => 2, 1 => 1, 2 => 0,
		3 => 5, 4 => 4, 5 => 3,
		6 => 8, 7 => 7, 8 => 6}

	def initialize(name, rng = Random.new)
		@rng = rng
		@name = name
		@winning_moves = Hash.new
		@drawing_moves = Hash.new
		@losing_moves = Hash.new
		@games_move_history = Hash.new
	end

	def declare_victorious(board, game_id)

	end

	def declare_defeated(board, game_id)

	end

	def declare_draw(board, game_id)

	end

	def take_a_turn(board, game_id)
		if !(@games_move_history.has_key? game_id)
			new_move_queue = Queue.new
			@games_move_history[game_id] = new_move_queue
		end
		move = choose_next_move(board)
		@games[game_id].push move
	end




	def choose_next_move(board)
		board_array = Array.new
		0..8.each do |position|
			board_array[position] = board.check_position(position)
		end
		board_hash = get_board_hash(board_array)
		find_move(board, board_hash.hash, board_hash.rotation, board_hash.reflection)
	end

	def get_board_hash(board_array)
		hashes_info = Array.new
		(0..3).each do |rotation|
			hashes_info.push(calculate_board_hash(board_array, rotation: rotation, reflection: false))
			hashes_info.push(calculate_board_hash(board_array, rotation: rotation, reflection: true))
		end
		result = hashes_info.find { |hash| @winning_moves.has_key?(hash.hash) || @drawing_moves.has_key?(hash.hash) || @losing_moves.has_key?(hash.hash) }
		if result.nil?
			result = hashes_info.first
		end
		result
	end

	def find_move(board, hash, rotation, reflection)
		if @winning_moves.has_key?(hash)
			list_of_moves = @winning_moves[hash]
		elsif @drawing_moves.has_key?(hash)
			list_of_moves = @drawing_moves[hash]
		elsif @losing_moves.has_key?(hash)
			list_of_moves = @losing_moves[hash]
		else
			list_of_moves = (0..8).to_a.select { |move| board.legal_move? move}
			@winning_moves[hash] = list_of_moves
		end
		move = list_of_moves[@rng.rand(list_of_moves.length)]
		convert(move, rotation, reflection)
	end

	def convert(move, rotation, reflection)
		converted_move = unrotate(move, rotation)
		if reflection
			converted_move = @@unreflect[move]
		end
		converted_move
	end

	def unrotate(move, rotation)
		if rotation == 0
			move
		else
			unrotate(@@unrotate[move], rotation - 1)
		end
	end

	# board.class == Array
	def calculate_board_hash(board_array, rotation = 0, reflection = false)
		if reflection
			array = reflect(board_array)
		else
			array = board_array
		end
		array = rotate(array, rotation)
		primes = [2, 3, 5, 7, 11, 13, 17, 19, 23]
		hash = 1
		0..8.each do |position|
			case array[position]
			when 'X'
				hash = hash * primes[position]
			when 'O'
				hash = hash * primes[position] * primes[position]
			else
				nil
			end
		end
		Hash_And_Board_Transformation.new(hash, rotation, reflection)
	end

	def reflect(array)
		[	array[2], array[1], array[0],
			array[5], array[4], array[3],
			array[8], array[7], array[6]]
	end

	def rotate(array, rotation)
		if rotation == 0
			array
		else
			rotated_array = [	array[2], array[1], array[0],
								array[5], array[4], array[3],
								array[8], array[7], array[6]]
			rotate(rotated_array, rotation - 1)
		end
	end
end

class Hash_And_Board_Transformation
	def initialize(hash, rotation, reflection)
		@hash = hash
		@rotation = rotation
		@reflection = reflection
	end

	def hash
		@hash
	end

	def rotation
		@@rotation
	end

	def reflection
		@reflection
	end
end