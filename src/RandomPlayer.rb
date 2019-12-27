class RandomPlayer
	def initialize(name)
		@name = name
	end

	def declare_victorious(board, game_id)

	end

	def declare_defeated(board, game_id)

	end

	def declare_draw(board, game_id)

	end

	def take_a_turn(board, game_id)
		Random.rand(9)
	end
end

