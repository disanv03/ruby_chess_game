require_relative '../lib/board'

describe Board do
  context 'on initialize' do
    subject(:init) { described_class.new }
    
    it 'creates an instance array to store data' do
      board = init.instance_variable_get(:@board)
      expect(board).to be_an(Array)
    end

    it 'array is 8x8' do
      board = init.instance_variable_get(:@board)
      expect(board.flatten.length).to eq(64)
    end

    it 'initialize to nil' do
      board = init.instance_variable_get(:@board)
      board.flatten.each do |index|
        expect(index).to be_nil
      end
    end

    it 'initializes trackers and counters to nil' do
      active = init.instance_variable_get(:@active)
      castle = init.instance_variable_get(:@castle)
      passant = init.instance_variable_get(:@passant)
      half = init.instance_variable_get(:@half)
      full = init.instance_variable_get(:@full)

      expect(active).to be_nil
      expect(castle).to be_nil
      expect(passant).to be_nil
      expect(half).to be_nil
      expect(full).to be_nil
    end
  end

  context '#make_board' do
    context 'when there are unrecognized charaters in the notation' do
      subject(:fen_error) { described_class.new }

      it 'raises an ArgumentError (special char $)' do
        input = 'rnbqkbnr/pp$ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'
        expect { fen_error.make_board(input) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError (digit > 8)' do
        input = 'rnbqkbnr/pppppppp/9/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'
        expect { fen_error.make_board(input) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError (letter != rnbqkp, case-insensitive)' do
        input = 'anbqkbnr/pppppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'
        expect { fen_error.make_board(input) }.to raise_error(ArgumentError)
      end


    end

    context 'generates the correct board representation for the given input' do
      subject(:fen_test) { described_class.new }

      it 'parses default starting position and generates the correct board' do
        fen_test.make_board
        board = fen_test.instance_variable_get(:@board)
        active = fen_test.instance_variable_get(:@active)
        full = fen_test.instance_variable_get(:@full)

        expect(board[0][0].coordinate).to eq('a8')
        expect(board[0][0].content).to eq('r')
        expect(board[2][0].coordinate).to eq('a6')
        expect(board[2][0].content).to be_nil
        expect(board[4][3].coordinate).to eq('d4')
        expect(board[4][3].content).to be_nil
        expect(board[7][6].coordinate).to eq('g1')
        expect(board[7][6].content).to eq('N')

        expect(full).to eq(1)
        expect(active).to eq('w')
      end

      it 'parses notation with pieces moved correctly' do
        input = 'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'
        fen_test.make_board(input)
        board = fen_test.instance_variable_get(:@board)
        active = fen_test.instance_variable_get(:@active)
        full = fen_test.instance_variable_get(:@full)

        expect(board[3][1].coordinate).to eq('b5')
        expect(board[3][1].content).to be_nil
        expect(board[3][2].coordinate).to eq('c5')
        expect(board[3][2].content).to eq('p')
        expect(board[4][3].coordinate).to eq('d4')
        expect(board[4][3].content).to be_nil
        expect(board[4][4].coordinate).to eq('e4')
        expect(board[4][4].content).to eq('P')
        expect(board[4][5].coordinate).to eq('f4')
        expect(board[4][5].content).to be_nil 

        expect(full).to eq(2)
        expect(active).to eq('b')
      end
    end
    context '#make_fen' do
      subject(:get_fen) { described_class.new }

      it 'generates and outputs FEN notation from a given board state' do
        get_fen.make_board
        fen = get_fen.make_fen
        expect(fen).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      end
    end

    context 'coordinates conversions' do
      context '#arr_to_std_chess' do
        subject(:coords) { described_class.new }

        it 'takes an array of 2 elements and returns the right chess notation' do
          expect(coords.arr_to_std_chess([1,2])).to eq('c7')
          expect(coords.arr_to_std_chess([0, 0])).to eq('a8')
          expect(coords.arr_to_std_chess([4, 4])).to eq('e4')
          expect(coords.arr_to_std_chess([7, 7])).to eq('h1')
        end

        it 'returns nil if coordinate are out of range' do
          expect(coords.arr_to_std_chess([8, 8])).to be_nil
        end
      end

      context '#std_chess_to_arr' do
        subject(:coords) { described_class.new }

        it 'takes a string of chess notation and returns the right array coordinates' do
          coords.make_board
          expect(coords.std_chess_to_arr('c7')).to eq([1, 2])
          expect(coords.std_chess_to_arr('a8')).to eq([0, 0])
          expect(coords.std_chess_to_arr('e4')).to eq([4, 4])
          expect(coords.std_chess_to_arr('h1')).to eq([7, 7])
        end

        it 'returns nil if notation are out of range' do
          expect(coords.std_chess_to_arr('j8')).to be_nil
        end
      end
    end

    context '#cell' do 
      subject(:cells) { described_class.new }
      
      it 'takes a string notation and returns the correct cell object' do
        cells.make_board
        test_cell = cells.cell('a8')
        expect(test_cell).to have_attributes(coordinate: 'a8')
      end
    end

    context '#make_move' do
      subject(:move_update) { described_class.new }
      it 'make a move from an origin to a destination cell' do
        move_update.make_board
        to = move_update.cell('a6')
        expect { move_update.make_move('a7', 'a6') }.to change {to.content}.from(nil).to('p')
      end
    end
  end
end

