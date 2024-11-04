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

    it 'display random position' do
    end
  end
end

