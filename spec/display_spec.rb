require_relative '../lib/display'
require_relative '../lib/board'

describe Display do
  let(:board) {Board.new}
  subject(:display) {described_class.new(board)}

  context 'shows a provided board' do
    it 'displays starting board position' do
      board.make_board
      display.show_board
      expect {display.show_board}.to output.to_stdout
    end
  end

  context 'with a selected piece, display the provided list of moves' do
    it 'display possible moves, with captures' do
      board.make_board('8/8/3pp3/8/3n4/8/2P5/8 b - - 1 2')
      eligible = %w[c2 e2 b3 b5 c6 f5 f3].sort
      display.show_board(moves: eligible)
      expect {display.show_board(moves: eligible)}.to output.to_stdout
    end


    it 'displays the board, with captures and valies moves given' do
      board.make_board('8/8/4PP2/8/4N3/8/3p4/8 b - - 1 2')
      eligible = %w[d2 f2 g3 g5 d6 c5 c3].sort
      display.show_board(moves: eligible)
      expect {display.show_board(moves: eligible)}.to output.to_stdout
    end
  end
end

