class AIPlayer

	@@unrotate = {
		0 => 6, 1 => 3, 2 => 0,
		3 => 7, 4 => 4, 5 => 1,
		6 => 8, 7 => 5, 8 => 2}

	@@rotate = {
		0 => 2, 1 => 5, 2 => 8,
		3 => 1, 4 => 4, 5 => 7,
		6 => 0, 7 => 3, 8 => 6}

	@@reflect = {
		0 => 2, 1 => 1, 2 => 0,
		3 => 5, 4 => 4, 5 => 3,
		6 => 8, 7 => 7, 8 => 6}

	def initialize(name, rng = Random.new)
		@rng = rng
		@name = name
		@winning_moves = Hash.new
		@drawing_moves = Hash.new
		@losing_moves = Hash.new
		@games_move_history = [nil, Hash.new, Hash.new]
	end

	def declare_victorious(board, game_id, num)
		@games_move_history[num].delete(game_id)
	end

	def declare_defeated(board, game_id, num)
		mark_last_move_as_losing(game_id, num)
		@games_move_history[num].delete(game_id)
	end

	def mark_last_move_as_losing(game_id, num)
		if @games_move_history[num][game_id].length > 0
			last_move = @games_move_history[num][game_id].pop
			puts "last move: #{last_move.move}"
			if @winning_moves[last_move.board_hash].include?(last_move.move)
				puts "last move: #{last_move.move}, from winning to losing"
				@winning_moves[last_move.board_hash].delete(last_move.move)
				@losing_moves[last_move.board_hash].push(last_move.move)
				if @winning_moves[last_move.board_hash].empty?
					if @drawing_moves[last_move.board_hash].empty?
						puts "no more winning or drawing moves, changing previous move to losing"
						mark_last_move_as_losing(game_id, num)
					else
						puts "no more winning moves, changing previous move to drawing"
						mark_last_move_as_drawing(game_id, num)
					end
				end
			elsif @drawing_moves[last_move.board_hash].include?(last_move.move)
				puts "last move: #{last_move.move}, from drawing to losing"
				@drawing_moves[last_move.board_hash].delete(last_move.move)
				@losing_moves[last_move.board_hash].push(last_move.move)

				if @drawing_moves[last_move.board_hash].empty?
					puts "no more winning or drawing moves, changing previous move to losing"
					mark_last_move_as_losing(game_id, num)
				end
			else
				puts "last move: #{last_move.move}, was losing already"
			end

		end
	end

	def mark_last_move_as_drawing(game_id, num)
		if @games_move_history[num][game_id].length > 0
			last_move = @games_move_history[num][game_id].pop
			puts "last move: #{last_move.move}"
			if @winning_moves[last_move.board_hash].include?(last_move.move)
				puts "last move: #{last_move.move}, from winning to drawing"
				@winning_moves[last_move.board_hash].delete(last_move.move)
				@drawing_moves[last_move.board_hash].push(last_move.move)
				if @winning_moves[last_move.board_hash].empty?
					puts "no more winning moves, changing previous move to drawing"
					mark_last_move_as_drawing(game_id, num)
				end
			else
				puts "last move: #{last_move.move}, was drawing already"
			end
		end
	end

	def declare_draw(board, game_id, num)
		mark_last_move_as_drawing(game_id, num)
		@games_move_history[num].delete(game_id)
	end

	def take_a_turn(board, game_id, num)
		if !(@games_move_history[num].has_key? game_id)
			new_move_queue = Array.new
			@games_move_history[num][game_id] = new_move_queue
		end
		board_array = board.to_a
		board_hash = get_board_hash(board_array)
		move = find_move(board_hash.board_hash, board_hash.array)
		@games_move_history[num][game_id].push MoveHistoryEntry.new(move, board_hash.board_hash)
		AIPlayer.convert(move, board_hash.rotation, board_hash.reflection)
	end

	def get_board_hash(board_array)
		hashes_info = Array.new
		(0..3).each do |rotation|
			hashes_info.push(AIPlayer.calculate_board_hash(board_array, rotation, false))
			hashes_info.push(AIPlayer.calculate_board_hash(board_array, rotation, true))
		end
		result = hashes_info.find { |board_hash| @winning_moves.has_key?(board_hash.board_hash) || @drawing_moves.has_key?(board_hash.board_hash) || @losing_moves.has_key?(board_hash.board_hash) }
		if result.nil?
			result = hashes_info.first
		end
		result
	end

	def find_move(board_hash, array)
		if @winning_moves.has_key?(board_hash) && @winning_moves[board_hash].any?
			puts "found winning moves"
			list_of_moves = @winning_moves[board_hash]
		elsif @drawing_moves.has_key?(board_hash) && @drawing_moves[board_hash].any?
			puts "found drawing moves"
			list_of_moves = @drawing_moves[board_hash]
		elsif @losing_moves.has_key?(board_hash) && @losing_moves[board_hash].any?
			puts "found losing moves"
			list_of_moves = @losing_moves[board_hash]
		else
			list_of_moves = (0..8).to_a.select { |move| array[move].nil? }
			@winning_moves[board_hash] = list_of_moves
			@drawing_moves[board_hash] = Array.new
			@losing_moves[board_hash] = Array.new
			puts "found no moves, creating new list: #{list_of_moves.to_s}"
		end
		list_of_moves[@rng.rand(list_of_moves.length)]
	end

	def self.convert(move, rotation, reflection)
		converted_move = AIPlayer.unrotate(move, rotation)
		if reflection
			converted_move = @@reflect[converted_move]
		end
		converted_move
	end

	def self.unrotate(move, rotation)
		if rotation == 0
			move
		else
			AIPlayer.unrotate(@@unrotate[move], rotation - 1)
		end
	end

	# board.class == Array
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
		Hash_And_Board_Transformation.new(board_hash, rotation, reflection, array)
	end

	def self.reflect(array)
		[array[2], array[1], array[0],
		 array[5], array[4], array[3],
		 array[8], array[7], array[6]]
	end

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
end

class Hash_And_Board_Transformation
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

class MoveHistoryEntry
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