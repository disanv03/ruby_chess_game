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
     end

      context 'when there is a friendly piece on the path' do
        it 'when the rook starts on a8, return the correct list of moves' do
        end

        it 'when the rook is on d4, provides the correct list of moves' do
        end
      end

      context 'when there is an enenmy piece on the path' do
        it 'when the rook is on a8, return the correct list of moves, including capture' do
        end
        it 'when the rook is on d4, provides the correct list of moves' do
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
      end

  end

  context '#valid_moves' do
    context 'when provided a cell with a rook' do
      it 'moves the piece in bounds as expected and returns true' do
      end

      it 'does not move the piece and return false' do
      end
    end
  end
end
