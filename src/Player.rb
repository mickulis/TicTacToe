class Player
	def initialize(name)
		@name = name
	end

	def declare_victorious(board, game_id)
		puts "#{@name} won\n"
		display(board)
		gets
	end

	def declare_defeated(board, game_id)
		puts "#{@name} lost\n"
		display(board)
		gets
	end

	def declare_draw(board, game_id)
		puts "#{@name} drawed\n"
		display(board)
		gets
	end

	def take_a_turn(board, game_id, num)
		# Gem.win_platform? ? (system "cls") : (system "clear")
		puts "Your turn #{@name}\n"
		display(board)
		input = get_input.to_i
		loop do
			#puts "input: #{input}: #{board.legal_move?(input)}\n"
			break if board.legal_move?(input)
			# Gem.win_platform? ? (system "cls") : (system "clear")
			#puts "input: #{input}: #{board.legal_move?(input)}\n"
			display(board)
			input = get_input.to_i
		end
		input
	end

	def display(board)
		puts board
	end

	def get_input
		input = gets
		input.to_i
	end
end
