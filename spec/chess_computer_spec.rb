# frozen-string-literal: true

require_relative '../lib/chess_computer'
require_relative '../lib/chess_piece'

describe ChessComputer do
  subject(:computer) { described_class.new }
  let(:chess_piece_class) { ChessPiece }

  describe '#checked_move' do
    let(:king_piece) { chess_piece_class.new(:king, 'E8') }

    before do
      allow(computer).to receive(:king).and_return([king_piece])
      allow(computer).to receive(:pieces).and_return([king_piece])
    end

    context "when the computers' king is in check" do
      let(:opponent_pieces) { [chess_piece_class.new(:queen, 'A4'), chess_piece_class.new(:king, 'E1')] }

      it 'should return the piece that should be moved' do
        expect(computer.checked_move(opponent_pieces)[:piece]).to eq(king_piece)
      end

      it 'should return the destination coordinate' do
        expected_destinations = %w[F8 F7 E7 D8]
        destination = computer.checked_move(opponent_pieces)[:destination]

        expect(expected_destinations).to include(destination)
      end

      context 'when checkmated' do
        let(:opponent_pieces) { [chess_piece_class.new(:rook, 'B7'), chess_piece_class.new(:rook, 'H8'), chess_piece_class.new(:king, 'E1')] }

        it 'should return nil' do
          expect(computer.checked_move(opponent_pieces)).to eq(nil)
        end
      end
    end

    context "when the computers' king is not in check" do
      let(:opponent_pieces) { [chess_piece_class.new(:bishop, 'E3'), chess_piece_class.new(:king, 'E1')] }

      it 'should return nil' do
        expect(computer.checked_move(opponent_pieces)).to eq(nil)
      end
    end

    context 'when opponent_pieces are empty' do
      let(:opponent_pieces) { [] }

      it 'should return nil' do
        expect(computer.checked_move(opponent_pieces)).to eq(nil)
      end
    end
  end

