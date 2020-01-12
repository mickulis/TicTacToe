require_relative '../src/Player/'
require_relative '../src/Board/'
RSpec.describe Player do
    context 'On ending state: ' do
        player_name = "Test"
        test_player = Player.new(player_name)
        board = Board.new

        it "verifies declaring victory of player #{player_name}" do 
            allow($stdin).to receive(:gets).and_return('not_used')
            $stdout = StringIO.new
            test_player.declare_victorious(board, nil, nil)
            output = $stdout.string.split("\n")
            expect(output.first).to eq("#{player_name} won")
        end

        it "verifies declaring defeat of player #{player_name}" do 
            allow($stdin).to receive(:gets).and_return('not_used')
            $stdout = StringIO.new
            test_player.declare_defeated(board, nil, nil)
            output = $stdout.string.split("\n")
            expect(output.first).to eq("#{player_name} lost")
        end

        it "verifies declaring draw of player #{player_name}" do 
            allow($stdin).to receive(:gets).and_return('not_used')
            $stdout = StringIO.new
            test_player.declare_draw(board, nil, nil)
            output = $stdout.string.split("\n")
            expect(output.first).to eq("#{player_name} drawed")
        end
    end
    context 'Asking the player for a move:' do
        player_name = "Test"
        test_player = Player.new(player_name)
        it 'tells which player turn it is and inputs legal move' do
            board = Board.new
            for legal_move_inp in [*('0'..'8')] do
                allow($stdin).to receive(:gets).and_return(legal_move_inp)
                $stdout = StringIO.new
                legal_move = test_player.take_a_turn(board, nil, nil)
                output = $stdout.string.split("\n")
                expect(legal_move).to(eq(legal_move_inp.to_i))                
                expect(output.first).to eq("Your turn #{player_name}")
            end
        end
        it 'tries to do illegal move not on board' do 
            board = Board.new
            $stdout = StringIO.new
            illegal_inp = rand(255).chr
            loop do
                break if ((0..255).to_a.map(&:chr) - ('0'..'9').to_a).include? illegal_inp
                illegal_inp = rand(255).chr
            end
            legal_move_inp = ('1'..'8').to_a.sample
            allow($stdin).to receive(:gets).and_return(illegal_inp)
            # Try any ascii char as input
            legal_move = test_player.take_a_turn(board, nil, nil)          
            # interpreter should parse it as 0 - added first
            expect(legal_move).to(eq('0'.to_i))
            # Try integer
            illegal_inp = rand(9..100).to_s
            allow($stdin).to receive(:gets).and_return(illegal_inp, legal_move_inp)
            # Insert wrong input and then correct one
            legal_move = test_player.take_a_turn(board, nil, nil)          
            expect(legal_move).to(eq(legal_move_inp.to_i))  
            # Board should not be updated
            expect(board.filled).to(eq(0))
        end
        it 'tries to do illegal duplicated move' do
            board = Board.new
            empty_board = board.to_s
            allow($stdin).to receive(:gets).and_return('5', '5', '0')
            legal_move = test_player.take_a_turn(board, nil, nil)
            board.insert(legal_move, "X")
            $stdout = StringIO.new
            test_player.take_a_turn(board, nil, nil)
            output = $stdout.string.split("\n")
            # Board should be empty
            expect(board.filled).to(eq(1))
            expect(output.first).to(eq("Your turn #{player_name}"))
            expect(output.drop(1).take(5).join('')).to(eq(output.drop(6).take(5).join('')))
        end
    end
  end
  