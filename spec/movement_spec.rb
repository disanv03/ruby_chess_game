require_relative '../lib/movement'
require_relative '../lib/board'

describe Movement do
  context 'on initialize' do
    let(:test_board) { Board.new }
    subject(:move_init) { described_class.new(test_board.board) }

    it 'stores a reference of the board properly' do
      test_board.make_board
      board_data = move_init.instance_variable_get(:@board)
      expect(board_data.flatten.length).to eq(64)
      board_data.each do |rank|
        rank.each do |cell|
          expect(cell).to be_a(Cell)
        end
      end
    end
  end

  context '#horizontal_move' do
    let(:board) { Board.new }

    context 'with a rook' do
    subject(:rook_test) { described_class.new(board) }

      context 'on an empty board' do
        it 'when rook is on a8, provides the correct list of moves options' do
          board.make_board('r7/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.horizontal_move(cell)).to eq(%w(b8 c8 d8 e8 f8 g8 h8))
        end

        it 'when the rook is on d4, provides the correct list of moves options' do
          board.make_board('8/8/8/8/3r4/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(a4 b4 c4 e4 f4 g4 h4))
        end
      end

      context 'when there is a friendly piece on the path' do
        it 'when the rook starts on a8, return the correct list of moves' do
          board.make_board('r4b2/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.horizontal_move(cell)).to eq(%w[b8 c8 d8 e8])
        end

        it 'when the rook is on d4, provides the correct list of moves' do
          board.make_board('8/8/8/8/3rb3/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w[a4 b4 c4])
        end
      end

      context 'when there is an enenmy piece on the path' do
        it 'when the rook is on a8, return the correct list of moves, including capture' do
          board.make_board('r4B2/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.horizontal_move(cell)).to eq(%w(b8 c8 d8 e8 f8))
        end
        it 'when the rook is on d4, provides the correct list of moves' do
          board.make_board('8/8/8/8/3rB3/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(a4 b4 c4 e4))
        end
      end

      context 'when there are multiple enemy pieces on the path' do
        it 'when the Rook is on a8, returns the correct list with one capture only' do
          board.make_board('r4BN1/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.horizontal_move(cell)).to eq(%w(b8 c8 d8 e8 f8))
        end
        it 'when the Rook is on d4, returns the correct list with two captures on either side only' do
          board.make_board('8/8/8/8/1RPrBN2/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(c4 e4))
        end
      end

      context 'when there is a friendly piece on one side, and an enemy piece on the other' do
        it 'the rook from d4, returns the correct list of available moves, including a capture' do
          board.make_board('8/8/8/8/2prBN2/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(e4))
        end
      end
    end
      
      context 'with a king' do
        subject(:king_test) { described_class.new(board) }

        context 'on an empty board' do
          it 'when a king is on a8, provides the correct list of horizontal moves' do
            board.make_board('k7/8/8/8/8/8/8/8 b - - 1 2')
            cell = board.cell('a8')
            expect(king_test.horizontal_move(cell)).to eq(%w(b8))
          end

          it 'when the king is on d4, provides the correct list of horizontal moves' do
            board.make_board('8/8/8/8/3k4/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(c4 e4))
          end
        end

        context 'when there is a friendly piece beside the king' do
          it 'starting from a8, return the correct list of moves' do
            board.make_board('kn6/8/8/8/8/8/8/8 b - - 1 2')
            cell = board.cell('a8')
            expect(king_test.horizontal_move(cell)).to eq(%w())
          end

          it 'starting from d4, return the correct list of available moves' do
            board.make_board('8/8/8/8/2nkp3/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w())
          end
        end

        context 'when there is an enemy piece on the path' do
          it 'King start from a8, return the correct list of valid moves including capture' do
            board.make_board('kN6/8/8/8/8/8/8/8 b - - 1 2')
            cell = board.cell('a8')
            expect(king_test.horizontal_move(cell)).to eq(%w(b8))
          end

          it 'the king starting from d4, retrun the correct list of moves includings both captures' do
            board.make_board('8/8/8/8/2PkP3/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(c4 e4))
          end
        end

        context' where there are multiple enemy pieces on the path' do
          it 'the king from a8, return the correct list moves including the correct capture' do
            board.make_board('kNK5/8/8/8/8/8/8/8 b - - 1 2')
            cell = board.cell('a8')
            expect(king_test.horizontal_move(cell)).to eq(%w(b8))
          end

          it 'starting from d4, returns correct list of moves including correct capture' do
            board.make_board('8/8/8/8/1PPkPP2/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(c4 e4))
          end

          it 'starting from d4 with a friendly piece on one side, and enemy on the other' do
            board.make_board('8/8/8/8/2pkP3/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(e4))
          end


        end
      end
  end

  context '#find_vertical_moves works' do
    let(:board) { Board.new }
    context 'with a rook' do
      subject(:rook_test) { described_class.new(board) }

      context 'on an empty board' do
        it 'rook starts on a8, return the correct list of available moves' do
          board.make_board('r7/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.vertical_move(cell)).to eq(%w[a1 a2 a3 a4 a5 a6 a7])
        end

        it 'rook start on d4, return the correct list of available moves' do
          board.make_board('8/8/8/8/3r4/8/8/8 b - - 1 2')
        end
      end

      context 'where there is a friendly piece on the path' do
        it 'rook start on a8, return the correct list of available moves' do
        
        end

        it 'the rook start on d4, return the correct list of available moves' do

        end
      end
      
      context 'when there are multiple enemy pieces on the path' do
        it 'rook start a8, return the correct list of moves including a capture' do
        end

        it 'rook start d4, return the correct list of moves including both side captures' do
        end
      end

      context 'when there is a friendly on one side, and an enemy on the other' do
        it 'rook start on d4, return the correct list of available moves including a capture' do
        end
      end


    end

    context 'with a king' do
      subject(:king_test) { described_class.new(board) }

      context 'on an empty board' do
      end

      context 'where there is a friendly piece on the path' do
      end

      context 'where there is an enemy piece on the path' do
      end

      context 'where there is a friendly piece on one side, and an enemy on the other' do
      end
    end
  end

end
