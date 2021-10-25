# frozen-string-literal: true

require_relative '../lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new(unicode_bishop) }
  let(:unicode_bishop) { '🨃' }

  describe '#left_down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(bishop.left_down).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from the left down from H5' do
        position = 'H5'
        bishop.position = position
        moves = %w[G4 F3 E2 D1]
        expect(bishop.left_down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'H1'
        bishop.position = position
        moves = []
        expect(bishop.left_down).to eq(moves)
      end
    end
  end
end
