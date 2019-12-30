require_relative '../test_helper'
require 'minitest/autorun'
require_relative '../src/Game/'
# Common test data version: 1.7.0 cacf1f1
class GameTest < Minitest::Test
	def test_fill_board__full
		p1 = MiniTest::Mock.new

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
end
