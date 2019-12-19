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

	def test_win_1st_row_with_X__X_wins
		board = Board.new
		board.insert(0, 'X')
		board.insert(1, 'X')
		board.insert(2, 'X')
		assert_equal('X', board.victory?)
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
end
