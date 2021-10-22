# frozen-string-literal: true

require_relative '../lib/rook.rb'

describe Rook do
  subject(:rook) { Rook.new(unicode_rook) }
  let(:unicode_rook) { '♖' }

  describe '#moveset' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(rook.moveset).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from coordinate D4' do
        position = 'D4'
        rook.position = position
        moves = [["E4"], ["F4"], ["G4"], ["H4"], ["D3"], ["D2"], ["D1"], ["C4"], ["B4"], ["A4"], ["D5"], ["D6"], ["D7"], ["D8"]]
        expect(rook.moveset).to eq(moves)
      end

      it 'should return the next valid moves from coordinate A1' do
        position = 'A1'
        rook.position = position
        moves = [["B1"], ["C1"], ["D1"], ["E1"], ["F1"], ["G1"], ["H1"], ["A2"], ["A3"], ["A4"], ["A5"], ["A6"], ["A7"], ["A8"]]
        expect(rook.moveset).to eq(moves)
      end

      it 'should return the next valid moves from coordinate H8' do
        position = 'H8'
        rook.position = position
        moves = [["H7"], ["H6"], ["H5"], ["H4"], ["H3"], ["H2"], ["H1"], ["G8"], ["F8"], ["E8"], ["D8"], ["C8"], ["B8"], ["A8"]]
        expect(rook.moveset).to eq(moves)
      end
    end
  end

  describe '#right_moves' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(rook.right_moves).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves to the right of coordinate B6' do
        position = 'B6'
        rook.position = position
        moves = [['C6'], ['D6'], ['E6'], ['F6'], ['G6'], ['H6']]
        expect(rook.right_moves).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'H8'
        rook.position = position
        moves = []
        expect(rook.right_moves).to eq(moves)
      end
    end
  end

  describe '#down_moves' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(rook.down_moves).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves down from coordinate G7' do
        position = 'G7'
        rook.position = position
        moves = [['G6'], ['G5'], ['G4'], ['G3'], ['G2'], ['G1']]
        expect(rook.down_moves).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'E1'
        rook.position = position
        moves = []
        expect(rook.down_moves).to eq(moves)
      end
    end
  end

  describe '#left_moves' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(rook.left_moves).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves to the left of coordinate E6' do
        position = 'E6'
        rook.position = position
        moves = [['D6'], ['C6'], ['B6'], ['A6']]
        expect(rook.left_moves).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'A6'
        rook.position = position
        moves = []
        expect(rook.left_moves).to eq(moves)
      end
    end
  end
end
