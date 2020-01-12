class RandomPlayer

	# AI that doesn't learn and makes moves randomly

	attr_reader :name
	def initialize(name)
		@name = name
		@rng = Random.new
	end

	# does nothing
	def declare_victorious(board, game_id, player_number)

	end

	# does nothing
	def declare_defeated(board, game_id, player_number)

	end

	# does nothing
	def declare_draw(board, game_id, player_number)

	end

	def take_a_turn(board, game_id, player_number)
		@rng.rand(9)
	end
end

