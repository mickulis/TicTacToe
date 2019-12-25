class Player
	def initialize(name)
		@name = name
	end

	def declare_victorious(board, game_id)
		puts "#{@name} won\n"
		display(board)
	end

	def declare_defeated(board, game_id)
		puts "#{@name} lost\n"
		display(board)
	end

	def declare_draw(board, game_id)
		puts "#{@name} drawed\n"
		display(board)
	end

	def take_a_turn(board, game_id)
		Gem.win_platform? ? (system "cls") : (system "clear")
		puts "Your turn #{@name}\n"
		display(board)
		input = get_input.to_i
		loop do
			puts "input: #{input}: #{board.legal_move?(input)}\n"
			break if board.legal_move?(input)
			Gem.win_platform? ? (system "cls") : (system "clear")
			puts "input: #{input}: #{board.legal_move?(input)}\n"
			display(board)
			input = get_input.to_i
		end
		input
	end

	def display(board)
		array = Array.new
		for i in 0..8 do
			value = board.check_position(i)
			if value.nil?
				array[i] = "\x1b[38;2;100;100;100m#{i}\x1b[38;2;255;255;255m"
			else
				array[i] = value
			end
		end

		puts " #{array[0]} | #{array[1]} | #{array[2]}\n"\
			" --+---+--\n"\
			" #{array[3]} | #{array[4]} | #{array[5]}\n"\
			" --+---+--\n"\
			" #{array[6]} | #{array[7]} | #{array[8]}\n"
	end

	def get_input
		input = gets
		input.to_i
	end
end
