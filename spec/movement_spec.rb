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
          expect(rook_test.horizontal_move(cell)).to eq(%w(b8 c8 d8 e8 xf8))
        end
        it 'when the rook is on d4, provides the correct list of moves' do
          board.make_board('8/8/8/8/3rB3/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(a4 b4 c4 xe4))
        end
      end

      context 'when there are multiple enemy pieces on the path' do
        it 'when the Rook is on a8, returns the correct list with one capture only' do
          board.make_board('r4BN1/8/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('a8')
          expect(rook_test.horizontal_move(cell)).to eq(%w(b8 c8 d8 e8 xf8))
        end
        it 'when the Rook is on d4, returns the correct list with two captures on either side only' do
          board.make_board('8/8/8/8/1RPrBN2/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(xc4 xe4))
        end
      end

      context 'when there is a friendly piece on one side, and an enemy piece on the other' do
        it 'the rook from d4, returns the correct list of available moves, including a capture' do
          board.make_board('8/8/8/8/2prBN2/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          expect(rook_test.horizontal_move(cell)).to eq(%w(xe4))
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
            expect(king_test.horizontal_move(cell)).to eq(%w(xb8))
          end

          it 'the king starting from d4, retrun the correct list of moves includings both captures' do
            board.make_board('8/8/8/8/2PkP3/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(xc4 xe4))
          end
        end

        context' where there are multiple enemy pieces on the path' do
          it 'the king from a8, return the correct list moves including the correct capture' do
            board.make_board('kNK5/8/8/8/8/8/8/8 b - - 1 2')
            cell = board.cell('a8')
            expect(king_test.horizontal_move(cell)).to eq(%w(xb8))
          end

          it 'starting from d4, returns correct list of moves including correct capture' do
            board.make_board('8/8/8/8/1PPkPP2/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(xc4 xe4))
          end

          it 'starting from d4 with a friendly piece on one side, and enemy on the other' do
            board.make_board('8/8/8/8/2pkP3/8/8/8 b - - 1 2')
            cell = board.cell('d4')
            expect(king_test.horizontal_move(cell)).to eq(%w(xe4))
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
      subject(:king_test) { described_class.new(board) }

      context 'on an empty board' do
        it 'king start on a8, return the correct list of available moves' do
          board.make_board('k7/8/8/8/8/8/8/8 b -- 1 2')
          cell = board.cell('a8')
          expect(king_test.vertical_move(cell)).to eq(%w[a7])
        end

        it 'king start on d4, return the correct list of available moves' do
          board.make_board('8/8/8/8/3k4/8/8/8 b -- 1 2')
          cell = board.cell('d4')
          expect(king_test.vertical_move(cell)).to eq(%w[d3 d5])
        end
      end

      context 'where there is a friendly piece on the path' do
        it 'king start on d4, returns correct list of moves' do
          board.make_board('8/8/8/3p4/3k4/8/8/8 b -- 1 2')
          cell = board.cell('d4')
          expect(king_test.vertical_move(cell)).to eq(%w[d3])
        end
      end

      context 'where there is an enemy piece on the path' do
        it 'king start on d4, returns correct list of moves' do
          board.make_board('8/8/8/3N4/3k4/8/8/8 b -- 1 2')
          cell = board.cell('d4')
          expect(king_test.vertical_move(cell)).to eq(%w[d3 xd5].sort)
        end
      end

      context 'where there is a friendly piece on one side, and an enemy on the other' do
        it 'king start on d4, returns correct list of moves' do
          board.make_board('8/8/8/3N4/3k4/3p4/8/8 b -- 1 2')
          cell = board.cell('d4')
          expect(king_test.vertical_move(cell)).to eq(["xd5"])
        end
      end

    end
  end

  context '#diagonal move' do
    let(:board) { Board.new }

    context 'with a bishop' do
      subject(:bishop_test) { described_class.new(board) }

      context 'on an empty board' do
          it 'bishop start on c7, return the correct list of moves' do
            board.make_board('8/2b5/8/8/8/8/8/8 b -- 1 2')
            cell = board.cell('c7')
            eligible = %w[a5 b6 d8 b8 d6 e5 f4 g3 h2].sort
            expect(bishop_test.diagonal_move(cell)).to eq(eligible)
          end

          it 'bishop start on a8, return the correct list of available moves' do
             board.make_board('b7/8/8/8/8/8/8/8 b -- 1 2')
             cell = board.cell('a8')
             expect(bishop_test.diagonal_move(cell)).to eq(%w[b7 c6 d5 e4 f3 g2 h1])
          end
      end

      context 'when there is a friendly piece on the path' do
        it 'bishop stand on c7, return correct list of moves' do
          board.make_board('1n6/2b5/8/8/8/8/8/8 b -- 1 2')
          cell = board.cell('c7')
          eligible = %w[a5 b6 d8 d6 e5 f4 g3 h2].sort
          expect(bishop_test.diagonal_move(cell)).to eq(eligible)
        end

        it'bishop stand on d4, return correct list of moves' do
          board.make_board('8/8/1p3p2/8/3b4/8/1n7/8 b -- 1 2')
          cell = board.cell('d4')
          eligible = %w[c5 e5 c3 e3 f2 g1].sort
          expect(bishop_test.diagonal_move(cell)).to eq(eligible)
        end
      end

      context 'when there are multiple enemy pieces on the path' do
        it 'bishop stand on c7, returns correct list of moves including capture' do
          board.make_board('1N6/2b5/8/4P3/5B2/8/8/8 b -- 1 2')
          cell = board.cell('c7')
          eligible = %w[a5 b6 xb8 d8 d6 xe5].sort
          expect(bishop_test.diagonal_move(cell)).to eq(eligible)
        end

        it 'bishop stand on d4, returns correct list of moves including capture' do
          board.make_board('8/8/1P7/8/3b4/8/1n3P2/6N1 b -- 1 2')
          cell = board.cell('d4')
          eligible = %w[c5 xb6 e3 xf2 h8 g7 f6 e5 c3].sort
          expect(bishop_test.diagonal_move(cell)).to eq(eligible)

        end
      end
    
    end

  end

  context '#find_king_moves' do
    let(:board) { Board.new }
    subject(:king_test) { described_class.new(board) }
      context 'on a board with an enemy pieces' do
        it 'king on e6, prevents it from crossing vertical line of the f2 rook' do
          board.make_board('8/8/4k3/8/8/8/5R2/8 b - - 1 2')
          cell = board.cell('e6')
          eligible = %w[e7 d7 d6 d5 e5].sort
          expect(king_test.find_king_moves(cell)).to eq(eligible)
        end
        it 'king on e6, prevents it from crossing the horizontal line of the g5 rook' do
          board.make_board('8/8/4k3/6R1/8/8/8/8 b - - 1 2')
          cell = board.cell('e6')
          eligible = %w[d6 f6 d7 e7 f7].sort
          expect(king_test.find_king_moves(cell)).to eq(eligible)
        end
        it 'king on e6, prevents it from crossing the diagonal line of the f3 bishop' do
          board.make_board('8/8/4k3/8/8/5B2/8/8 b - - 1 2')
          cell = board.cell('e6')
          eligible = %w[d6 d7 e7 f7 f6 f5 e5].sort
          expect(king_test.find_king_moves(cell)).to eq(eligible)
        end
        it 'king on e6, prevents from crossing diagonal and vertical line of f3 Bishop and f4 rook' do
          board.make_board('8/8/4k3/8/5R2/5B2/8/8 b - - 1 2')
          cell = board.cell('e6')
          eligible = %w[d7 e7 d6 e5].sort
          expect(king_test.find_king_moves(cell)).to eq(eligible)
        end
      end
  end

  context '#is_in_check' do
    let(:board) { Board.new }
    subject(:is_in_check_test) { described_class.new(board) }

    it '' do
    end
  end

  context '#find_knight_moves' do
    let(:board) { Board.new }
    subject(:knight_test) { described_class.new(board) }

    it 'return nil when a given piece is not a knight' do
      board.make_board('b7/8/8/8/8/8/8/8 b -- 1 2')
      cell = board.cell('a8')
      expect(knight_test.find_knight_moves(cell)).to be_nil
    end

    it 'on an empty board starting at a8, returns correct list of moves (testing out of bounds)' do
      board.make_board('n7/8/8/8/8/8/8/8 b - - 1 2')
      cell = board.cell('a8')
      eligible = %w[b6 c7].sort
      expect(knight_test.find_knight_moves(cell)).to eq(eligible)
    end

    it 'on an empty board starting at d4, returns correct list of availables moves' do
      board.make_board('8/8/8/8/3n4/8/8/8 b - - 1 2')
      cell = board.cell('d4')
      eligible = %w[c6 e6 f5 f3 e2 c2 b3 b5].sort
      expect(knight_test.find_knight_moves(cell)).to eq(eligible)
    end

    it 'on an non empty board starting at d4, returns the correct list of available moves including possible captures' do
      board.make_board('8/8/2b1P3/8/3n4/5p2/2P5/8 b - - 1 2')
      cell = board.cell('d4')
      eligible = %w[xe6 f5 e2 xc2 b3 b5].sort
      expect(knight_test.find_knight_moves(cell)).to eq(eligible)
    end

  end

  context '#find_moves' do
    let(:board) { Board.new }
    subject(:moves_test) { described_class.new(board) }

    context 'with a Queen as input' do
      context 'on an empty board' do
        it 'from d4, returns correct list of moves' do
          board.make_board('8/8/8/8/3q4/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[d8 d7 d6 d5 d3 d2 d1 a4 b4 c4 e4 f4 g4 h4 e5 f6 g7 h8 c3 b2 a1 c5 b6 a7 e3 f2 g1].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end

      context 'on a board with mixed pieces in its path' do
        it 'from d4, returns correct list of moves' do
          board.make_board('8/3p4/8/8/3qn3/8/3P1P2/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[a4 b4 c4 d5 d6 d3 xd2 a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 xf2].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end
    end
    
    context 'with a Knight as input' do
      context 'on an empty board' do
        it 'from d4, returns correct list of moves' do
          board.make_board('8/8/8/8/3n4/8/8/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[b5 c6 e6 f5 f3 e2 c2 b3].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end

      context 'on a board with mixed pieces in its path' do
        it 'from d4, returns correct list of moves' do
          board.make_board('8/8/2p1p3/8/3n4/8/2P5/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[f5 f3 e2 xc2 b3 b5].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end

    end

    context 'with a King as input' do
      context 'friendly piece on one side, enemy on the other' do
        it 'from d4, returns correct list of available moves including capture' do
          board.make_board('8/8/8/8/2pkP3/2N6/8/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[c5 d3 e3 e5 c3].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end

      context 'when there are a limited set of moves' do
        it 'correctly shows moves that prevent self-checking' do
          board.make_board('8/8/8/2k5/3R4/2B5/8/4K3 b - - 1 2')
          cell = board.cell('c5')
          eligible = %w[b6 c6 b5].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end

      context 'surrounding by enemy piece' do
        it 'correctly avoid self-checking moves' do
          board.make_board('8/8/8/8/2pkP3/3B4/8/8 b - - 1 2')
          cell = board.cell('d4')
          eligible = %w[c3 d3 e3 c5 e5].sort
          expect(moves_test.find_moves(cell)).to eq(eligible)
        end
      end
    end

    context 'with a Pawn as input' do
      context 'with a black Pawn' do
        context 'on an empty board' do
          it 'from c7, returns correct list of moves' do
          end
        end
        context 'on a board with other pieces' do
          it 'from c7, returns correct list of moves' do
            board.make_board('8/2p5/3P4/2p5/8/8/8/8 b - - 1 2')
            cell = board.cell('c7')
            eligible = %w[c6 xd6].sort
            expect(moves_test.find_moves(cell)).to eq(eligible)
          end
        end
      end

      context 'with a white Pawn' do
        context 'on an empty board' do
          it 'from e2, returns correct list of moves' do
            board.make_board('8/8/8/8/8/8/4P3/8 w - - 1 2')
            cell = board.cell('e2')
            eligible = %w[e3 e4]
            expect(moves_test.find_moves(cell)).to eq(eligible)
          end
        end
        context 'on a board with another pieces' do
          it 'from c2, returns correst list of moves' do
          end
        end
      end

    end

    context 'with a Rook as input' do
    end

    context 'with a Bishop as input' do
    end
  end

  context '#find_pawn_moves' do
    let(:board) { Board.new }
    subject(:pawn_test) { described_class.new(board) }

    context 'with a black pawn' do
      context 'on an empty board' do
        it 'starting at c7, returns correct list of moves, including double forward move' do
          board.make_board('8/2p5/8/8/8/8/8/8 b - - 1 2')
          cell = board.cell('c7')
          eligible = %w[c6 c5].sort
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end

        it 'starting at c6, returns correct list of available moves' do
          board.make_board('8/8/2p5/8/8/8/8/8 b - - 1 2')
          cell = board.cell('c6')
          eligible = ["c5"]
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end
      end

      context 'on a board with a fellow(same content)' do
        it 'starting at c7, returns correct moves, when path forward is blocked' do
          board.make_board('8/2p5/2p5/8/8/8/8/8 b - - 1 2')
          cell = board.cell('c7')
          eligible = []
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end

        it 'from c7, returns correct moves, when path blocked for the "double forward" move' do
          board.make_board('8/2p5/8/2p5/8/8/8/8 b - - 1 2')
          cell = board.cell('c7')
          eligible = ["c6"]
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end 
      end

      context 'on a board with other pieces' do
        context 'from c7' do
          it 'give correct list of moves, when fully blocked ahead with a capture available' do
            board.make_board('8/2p5/1Pn5/8/8/8/8/8 b - - 1 2')
            cell = board.cell('c7')
            eligible = ["xb6"]
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end

          it 'correct list of moves, when one move ahead is available and a capture' do
            board.make_board('8/2p5/3P4/2n5/8/8/8/8 b - - 1 2')
            cell = board.cell('c7')
            eligible = %w[c6 xd6].sort
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end
        end

        context 'from c5' do
          it 'give correct possibles move, fully blocked with two captures' do
            board.make_board('8/8/8/2p5/1PpP4/8/8/8 b - - 1 2')
            cell = board.cell('c5')
            eligible = %w[xb4 xd4].sort
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end
        end
      end

    context 'with a white pawn' do
      context 'on an empty board' do
        it 'starting at c2, returns correct list of moves, including double forward' do
          board.make_board('8/8/8/8/8/8/2P5/8 b - - 1 2')
          cell = board.cell('c2')
          eligible = %w[c3 c4]
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end

        it 'from c3, returns correct moves' do
          board.make_board('8/8/8/8/8/2P5/8/8 b - - 1 2')
          cell = board.cell('c3')
          eligible = ["c4"]
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end
      end

      context 'on a board with a fellow' do
        it 'from c2, returns correct list of moves, with fully blocked path' do
          board.make_board('8/8/8/8/8/2P5/2P5/8 b - - 1 2')
          cell = board.cell('c2')
          eligible = []
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end

        it 'from c2, retruns correct list of moves, path blocked for "double forward" only' do
          board.make_board('8/8/8/8/2P5/8/2P5/8 b - - 1 2')
          cell = board.cell('c2')
          eligible = ["c3"]
          expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
        end
      end
    end

      context 'on a board with others pieces' do
        context 'from c2' do
          it 'give correct list of moves, when fully blocked ahead with a capture' do
            board.make_board('8/8/8/8/8/1pN5/2P5/8 b - - 1 2')
            cell = board.cell('c2')
            eligible = ["xb3"]
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end

          it 'from c2, retruns correct list of moves, one move ahead available with a capture' do
            board.make_board('8/8/8/8/2N5/3p4/2P5/8 b - - 1 2')
            cell = board.cell('c2')
            eligible = %w[c3 xd3].sort
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end
        end

        context 'from c4' do
          it 'give correct list of moves, fully blocked with two captures' do
            board.make_board('8/8/8/1pNp4/2P5/8/8/8 b - - 1 2')
            cell = board.cell('c4')
            eligible = %w[xb5 xd5].sort
            expect(pawn_test.find_pawn_moves(cell)).to eq(eligible)
          end
        end
      end
    end
    
  end

end

