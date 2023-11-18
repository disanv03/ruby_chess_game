require_relative '../lib/board.rb'

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
  end
end

