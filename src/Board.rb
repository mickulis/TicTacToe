
class Board
	def initialize()
		@board = Array.new
		@victory_points = Array.new(8, 0)
		@filled = 0
	end

	def token_to_value(token)
		if token == 'X'
			1
		elsif token == 'O'
			-1
		else
			raise ArgumentError
		end
	end

	def insert(position, token)
		value = token_to_value(token)
		if check(position)
			@board[position] = value
			add_victory_points(position, value)
			@filled += 1
			true
		else
			false
		end
	end

	def legal_move?(position)
		@board[position].nil?
	end

	def check(position)
		if @board[position].nil?
			true
		else
			false
		end
	end

	def victory?
		if @victory_points.include? 3
			'X'
		elsif
		@victory_points.include? -3
			'O'
		elsif self.full?
			'DRAW'
		else
			false
		end
	end

	def full?
		@filled == 9
	end

	def add_victory_points(position, token)
		#row
		@victory_points[position/3 + 3] += token
		#column
		@victory_points[position % 3] += token

		#diagonals
		if position % 4 == 0
			@victory_points[6] += token
		end
		if (position.between?(1, 7)) && (position % 2 == 0)
			@victory_points[7] += token
		end
	end

end

