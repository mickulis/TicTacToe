class Board
	attr_accessor :filled
	def initialize
		@board = Array.new
		@victory_points = Array.new(8, 0) # explained in add_victory_points
		@filled = 0
	end

	# true if valid move, false if invalid, ArgumentError if wrong token
	# token = 'X' or 'O'
	def insert(position, token)
		value = token_to_value(token)
		if legal_move?(position)
			@board[position] = value
			add_victory_points(position, value)
			@filled += 1
			true
		else
			false
		end
	end

	# if position is taken, returns token, otherwise returns nil
	def check_position(position)
		if @board[position].nil?
			nil
		elsif @board[position] > 0
			'X'
		elsif @board[position] < 0
			'O'
		else
			nil
		end
	end

	# true if empty position, false if position taken, invalid argument or anything else
	def legal_move?(position)
		if position&.between?(0, 8) && @board[position].nil?
			true
		else
			false
		end
	end

	# 'X' if P1 wins, 'O' if P2 wins, 'DRAW' if board is full without a winner, false if board is not full without winner
	def victory?
		if @victory_points.include? 3
			'X'
		elsif
		@victory_points.include?(-3)
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

	def to_s
		array = Array.new
		for i in 0..8 do
			value = self.check_position(i)
			if value.nil?
				array[i] = "\x1b[38;2;100;100;100m#{i}\x1b[38;2;255;255;255m"
			else
				array[i] = value
			end
		end

		" #{array[0]} | #{array[1]} | #{array[2]}\n"\
		" --+---+--\n"\
		" #{array[3]} | #{array[4]} | #{array[5]}\n"\
		" --+---+--\n"\
		" #{array[6]} | #{array[7]} | #{array[8]}\n"
	end

	# returns copy of @board, but always of size 9
	def to_a
		array = Array.new
		(0..8).each do |position|
			array[position] = self.check_position(position)
		end
		array
	end


	private

	#
	# 0/1/2 - 1st/2nd/3rd column
	# 3/4/5 - 1st/2nd/3rd row
	#     6 - top left - bottom right diagonal
	#     7 - bottom left - top right diagonal
	#
	# +1 if 'X', -1 if 'O'
	# +3 anywhere = 'X' victory
	# -3 anywhere = 'O' victory
	#
	def add_victory_points(position, value)
		#row
		@victory_points[position/3 + 3] += value
		#column
		@victory_points[position % 3] += value

		#diagonals
		if position % 4 == 0
			@victory_points[6] += value
		end
		if (position.between?(1, 7)) && (position % 2 == 0)
			@victory_points[7] += value
		end
	end

	def token_to_value(token)
		if token == 'X'
			1
		elsif token == 'O'
			-1
		else
			raise ArgumentError.new("invalid token")
		end
	end
end

