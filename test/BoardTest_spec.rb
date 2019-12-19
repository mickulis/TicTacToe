require_relative '../src/Board/'

RSpec.describe Board do
	[0, 1, 2, 3, 4, 5, 6, 7, 8].each do |position|
		it "#{position} is inserted into board" do
			assert_equal true, Board.new.insert(position, 1)
		end
	end
end
