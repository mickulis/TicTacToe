require_relative '../test_helper'
require 'minitest/autorun'
require_relative '../src/Board/'
# Common test data version: 1.7.0 cacf1f1
class BoardTest < Minitest::Test
	[0, 1, 2, 3, 4, 5, 6, 7, 8].each do |position|
		define_method("test_insert_into_position_#{position}__success") do
			assert_equal(true, Board.new.insert(position, 'X'))
		end
		define_method("test_insert_into_position_twice_#{position}__failure") do
			board = Board.new
			board.insert(position, 'O')
			assert_equal false, board.insert(position, 'X')
		end
	end

	[[0, 1, 2],
	 [3, 4, 5],
	 [6, 7, 8],
	 [0, 3, 6],
	 [1, 4, 7],
	 [2, 5, 8],
	 [0, 4, 8],
	 [2, 4, 6]].each do |series_of_moves|
		define_method("test_perform_series_of_winning_moves_for_x_#{series_of_moves}__success") do
			board = Board.new
			series_of_moves.each do |move|
				board.insert(move, 'X')
			end
			assert_equal('X', board.victory?)
		end
		define_method("test_perform_series_of_winning_moves_for_o_#{series_of_moves}__success") do
			board = Board.new
			series_of_moves.each do |move|
				board.insert(move, 'O')
			end
			assert_equal('O', board.victory?)
		end
	end

	[[0, 4, 1, 6, 2],
	 [3, 1, 4, 2, 5],
	 [6, 1, 7, 2, 8],
	 [0, 1, 3, 2, 6],
	 [1, 1, 4, 2, 7],
	 [2, 1, 5, 2, 8],
	 [0, 1, 4, 2, 8],
	 [2, 1, 4, 2, 6]].each do |series_of_moves|
		define_method("test_perform_series_of_alternating_moves_where_x_wins_#{series_of_moves}__x_wins") do
			board = Board.new
			turn = 0
			series_of_moves.each do |move|
				if turn%2 == 0
					token = 'X'
				else
					token = 'O'
				end
				board.insert(move, token)
				turn = turn + 1
			end
			assert_equal('X', board.victory?)
		end
	end

	def test_fill_board__full
		board = Board.new
		board.insert(0, 'X')
		board.insert(1, 'X')
		board.insert(2, 'X')
		board.insert(3, 'X')
		board.insert(4, 'X')
		board.insert(5, 'X')
		board.insert(6, 'X')
		board.insert(7, 'X')
		board.insert(8, 'X')
		assert_equal(true, board.full?)
	end
	
	def test_check_position_and_illegal_moves
		board = Board.new
		for i in (0..8) do
			assert_equal(true, board.legal_move?(i))
			board.insert(i, 'O')
		end
		assert_equal('O', board.check_position(rand(8)))
		assert_equal(false, board.legal_move?(rand(8)))
		assert_equal(false, board.legal_move?(nil))
	end

	def test_fill_without_winner__draw
		board = Board.new
		board.insert(0, 'X')
		board.insert(1, 'X')
		board.insert(2, 'O')
		board.insert(3, 'O')
		board.insert(4, 'O')
		board.insert(5, 'X')
		board.insert(6, 'X')
		board.insert(7, 'X')
		board.insert(8, 'O')
		assert_equal 'DRAW', board.victory?
	end

	def test_invalid_token__token_to_value
		board = Board.new
		assert_raises ArgumentError do 
			board.insert(0, nil)
		end
	end

	def test_determine_else_winner__victory
		board = Board.new
		assert_equal(false, board.victory?)		
	end

	def test_print_board__to_s
		board = Board.new
		board.insert(0, 'X')
		board.insert(1, 'X')
		board.insert(2, 'X')
		board.insert(3, 'X')
		board.insert(4, 'X')
		board.insert(5, 'X')
		board.insert(6, 'X')
		board.insert(7, 'X')
		board.insert(8, 'X')
		array = board.to_a
		assert_equal(" #{array[0]} | #{array[1]} | #{array[2]}\n"\
		" --+---+--\n"\
		" #{array[3]} | #{array[4]} | #{array[5]}\n"\
		" --+---+--\n"\
		" #{array[6]} | #{array[7]} | #{array[8]}\n", board.to_s)		
	end
end
