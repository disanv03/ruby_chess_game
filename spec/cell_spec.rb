require_relative '../lib/cell'

describe Cell do
  context 'on empty initialize' do
    subject(:cell) { described_class.new }
    
    it 'defaults to empty' do
      expect(cell.empty?).to be_truthy
    end

    it 'has no coordinate' do
      expect(cell.coordinate).to be_nil
    end
  end

  context 'on piece initialize' do
    subject(:cell_knight) { described_class.new('N', 'b1') }
    it 'stores the correct coordinate' do
      expect(cell_knight.coordinate).to eq('b1')
    end

    it 'empty? returns the right status' do
      expect(cell_knight.empty?).to be_falsey
    end

    it 'correctly identifiers whether another piece can attack' do
      expect(cell_knight.capture?('n')).to be_truthy
      expect(cell_knight.capture?('K')).to be_falsey
    end
  end
end
