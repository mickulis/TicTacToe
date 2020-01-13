require_relative '../test_helper'
require 'minitest/autorun'
require_relative '../src/Game/'
# Common test data version: 1.7.0 cacf1f1
class GameTest < Minitest::Test
	def test_start_game_both_players_take_a_single_turn_X_wins
		p1 = MiniTest::Mock.new
		p2 = MiniTest::Mock.new
		board = MiniTest::Mock.new
		p1.expect(:take_a_turn, 0, [board, Integer, 1])
		p1.expect(:declare_victorious, nil, [board, Integer, 1])
		p2.expect(:take_a_turn, 1, [board, Integer, 2])
		p2.expect(:declare_defeated, nil, [board, Integer, 2])
		board.expect(:legal_move?, true, [0])
		board.expect(:insert, nil, [0, 'X'])
		board.expect(:victory?, false)
		board.expect(:legal_move?, true, [1])
		board.expect(:insert, nil, [1, 'O'])
		board.expect(:victory?, 'X')
		game = Game.new(p1, p2, board)
		game.start
		assert_equal('X', game.winner?)
		p1.verify
		p2.verify
		board.verify


	end

	def test_start_game_X_wins_in_one_move
		p1 = MiniTest::Mock.new
		p2 = MiniTest::Mock.new
		board = MiniTest::Mock.new
		p1.expect(:take_a_turn, 0, [board, Integer, 1])
		p1.expect(:declare_victorious, nil, [board, Integer, 1])
		p2.expect(:declare_defeated, nil, [board, Integer, 2])
		board.expect(:legal_move?, true, [0])
		board.expect(:insert, nil, [0, 'X'])
		board.expect(:victory?, 'X')
		game = Game.new(p1, p2, board)
		game.start
		assert_equal('X', game.winner?)
		p1.verify
		p2.verify
		board.verify
	end

	def test_start_game_X_loses_in_one_move
		p1 = MiniTest::Mock.new
		p2 = MiniTest::Mock.new
		board = MiniTest::Mock.new
		p1.expect(:take_a_turn, 0, [board, Integer, 1])
		p1.expect(:declare_defeated, nil, [board, Integer, 1])
		p2.expect(:declare_victorious, nil, [board, Integer, 2])
		board.expect(:legal_move?, true, [0])
		board.expect(:insert, nil, [0, 'X'])
		board.expect(:victory?, 'O')
		game = Game.new(p1, p2, board)
		game.start
		assert_equal('O', game.winner?)
		p1.verify
		p2.verify
		board.verify
	end

	def test_restart_of_drawed_game_raise_exception
		p1 = MiniTest::Mock.new
		p2 = MiniTest::Mock.new
		board = MiniTest::Mock.new
		p1.expect(:take_a_turn, 0, [board, Integer, 1])
		p1.expect(:declare_draw, nil, [board, Integer, 1])
		p2.expect(:declare_draw, nil, [board, Integer, 2])
		board.expect(:victory?, 'DRAW')
		board.expect(:legal_move?, true, [0])
		board.expect(:insert, nil, [0, 'X'])
		game = Game.new(p1, p2, board)
		game.start
		$stdout = StringIO.new
		assert_raises Exception do
			game.start
		end
		out2 = $stdout.string.split("\n")
		# Game not started because it was finished before
		assert_equal(0, out2.count)
		p1.verify
		p2.verify
		board.verify
	end
end
