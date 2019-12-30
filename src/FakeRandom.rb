class FakeRandom
	# pretends to be a random number generator, but returns 0 every time
	# this ensures that AI will always pick first available move
	def rand(i)
		0
	end
end
