require 'minitest/debugger' if ENV['DEBUG']
require_relative '../test_helper'
require 'minitest/autorun'
require_relative '../src/AIPlayer/'
require_relative '../src/FakeRandom/'
# Common test data version: 1.7.0 cacf1f1
class AIPlayerTest < Minitest::Test
  def test_ai_should_not_pick_losing_move
    fakeRand = MiniTest::Mock.new
    ai_player = AIPlayer.new('testAI', fakeRand)
    game_id = rand(1000)
    player_number = rand(2)+1
    board = MiniTest::Mock.new
    array =  [nil, nil, 'X',
              'X', 'X', 'X',
              'X', 'X', 'X']
    board.expect(:to_a, array)
    fakeRand.expect(:rand, 0, [Integer])
    move_first = ai_player.take_a_turn(board, game_id, player_number)
    ai_player.declare_defeated(board, game_id, player_number)
    board.expect(:to_a, array)
    fakeRand.expect(:rand, 0, [Integer])
    move_second = ai_player.take_a_turn(board, game_id, player_number)
    refute_equal(move_first, move_second)
  end

  def test_ai_should_not_pick_draw_move
    fakeRand = MiniTest::Mock.new
    ai_player = AIPlayer.new('testAI', fakeRand)
    game_id = rand(1000)
    player_number = rand(2)+1
    board = MiniTest::Mock.new
    array =  [nil, nil, 'X',
              'X', 'X', 'X',
              'X', 'X', 'X']
    board.expect(:to_a, array)
    fakeRand.expect(:rand, 0, [Integer])
    move_first = ai_player.take_a_turn(board, game_id, player_number)
    ai_player.declare_draw(board, game_id, player_number)
    board.expect(:to_a, array)
    fakeRand.expect(:rand, 0, [Integer])
    move_second = ai_player.take_a_turn(board, game_id, player_number)
    refute_equal(move_first, move_second)
  end

  def test_random_isomorphism_of_previous_game
		fakeRand = MiniTest::Mock.new
		fakeRand.expect(:rand, 0, [Integer])
    ai_player = AIPlayer.new('testAI', fakeRand)
    game_id = rand(1000)
    player_number = rand(2)+1
    board = MiniTest::Mock.new
		array =  [nil, 'X', 'O',
							nil, 'X', nil,
							nil, nil, nil]
		test_board = AIPlayer.rotate_clockwise(array, 2)
    board.expect(:to_a,array)
    move_first = ai_player.take_a_turn(board, game_id, player_number)
		array[move_first] = 'Test'

		# test board
    board.expect(:to_a, test_board)
    fakeRand.expect(:rand, 0, [Integer])
    move_second = ai_player.take_a_turn(board, game_id, player_number)
		test_board[move_second] = 'Test'

    assert_equal(AIPlayer.unrotate(move_second, 2), move_first)
    board.verify
  end

  def test_isomorphism_of_previous_game
    ai_player = AIPlayer.new('testAI', FakeRandom.new)
    game_id = rand(1000)
    player_number = rand(2)+1
    board = MiniTest::Mock.new
		# learning board
		array = [nil, nil, 'X', nil, nil, nil, nil, nil, nil]
		# expected selection
		array_mirror = AIPlayer.reflect(array)

		# testing board
		rotated = AIPlayer.rotate_clockwise(array, 1)
		rotated_mirror = AIPlayer.reflect(rotated)
		board.expect(:to_a, array)
    move_first = ai_player.take_a_turn(board, game_id, player_number)

    board.expect(:to_a, rotated)
    move_second = ai_player.take_a_turn(board, game_id, player_number)

    board.verify
    assert_equal(array_mirror.index('X'), move_first)
    assert_equal(rotated_mirror.index('X'), move_second)
  end

  def test_rotate_array_once
    array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
    rotated = AIPlayer.rotate_clockwise(array, 1)
    assert_equal('g', rotated[0])
    assert_equal('d', rotated[1])
    assert_equal('a', rotated[2])
    assert_equal('h', rotated[3])
    assert_equal('e', rotated[4])
    assert_equal('b', rotated[5])
    assert_equal('i', rotated[6])
    assert_equal('f', rotated[7])
    assert_equal('c', rotated[8])
  end

  def test_rotate_array_twice
    array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
    rotated = AIPlayer.rotate_clockwise(array, 2)
    assert_equal('i', rotated[0])
    assert_equal('h', rotated[1])
    assert_equal('g', rotated[2])
    assert_equal('f', rotated[3])
    assert_equal('e', rotated[4])
    assert_equal('d', rotated[5])
    assert_equal('c', rotated[6])
    assert_equal('b', rotated[7])
    assert_equal('a', rotated[8])
  end

  def test_reflect_array
    array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
    rotated = AIPlayer.reflect(array)
    assert_equal('c', rotated[0])
    assert_equal('b', rotated[1])
    assert_equal('a', rotated[2])
    assert_equal('f', rotated[3])
    assert_equal('e', rotated[4])
    assert_equal('d', rotated[5])
    assert_equal('i', rotated[6])
    assert_equal('h', rotated[7])
    assert_equal('g', rotated[8])
  end

  def test_rotate_then_unrotate
    array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
    reflected = AIPlayer.reflect(array)
    rotated = AIPlayer.rotate_clockwise(reflected, 1)
    
    assert_equal('a', rotated[AIPlayer.convert(0, 1, true)])
    assert_equal('b', rotated[AIPlayer.convert(1, 1, true)])
    assert_equal('c', rotated[AIPlayer.convert(2, 1, true)])
    assert_equal('d', rotated[AIPlayer.convert(3, 1, true)])
    assert_equal('e', rotated[AIPlayer.convert(4, 1, true)])
    assert_equal('f', rotated[AIPlayer.convert(5, 1, true)])
    assert_equal('g', rotated[AIPlayer.convert(6, 1, true)])
    assert_equal('h', rotated[AIPlayer.convert(7, 1, true)])
    assert_equal('i', rotated[AIPlayer.convert(8, 1, true)])
  end



end
