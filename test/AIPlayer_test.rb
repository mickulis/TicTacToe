require 'minitest/autorun'
require_relative '../src/AIPlayer/'
# Common test data version: 1.7.0 cacf1f1
class AIPlayerTest < Minitest::Test
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
		assert_equal(0, AIPlayer.convert(0, 0, false))
		assert_equal(6, AIPlayer.convert(0, 1, false))
		assert_equal(8, AIPlayer.convert(0, 2, false))
		assert_equal(2, AIPlayer.convert(0, 3, false))
		assert_equal(2, AIPlayer.convert(0, 0, true))
		assert_equal(0, AIPlayer.convert(0, 1, true))
		assert_equal(6, AIPlayer.convert(0, 2, true))
		assert_equal(8, AIPlayer.convert(0, 3, true))
		# assert_equal('a', rotated[AIPlayer.convert(0, 1, true)])
		# assert_equal('b', rotated[AIPlayer.convert(1, 1, true)])
		# assert_equal('c', rotated[AIPlayer.convert(2, 1, true)])
		# assert_equal('d', rotated[AIPlayer.convert(3, 1, true)])
		# assert_equal('e', rotated[AIPlayer.convert(4, 1, true)])
		# assert_equal('f', rotated[AIPlayer.convert(5, 1, true)])
		# assert_equal('g', rotated[AIPlayer.convert(6, 1, true)])
		# assert_equal('h', rotated[AIPlayer.convert(7, 1, true)])
		# assert_equal('i', rotated[AIPlayer.convert(8, 1, true)])
	end


end
