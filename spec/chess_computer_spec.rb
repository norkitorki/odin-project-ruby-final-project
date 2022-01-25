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

  describe '#capture_move' do
    let(:knight_piece) { chess_piece_class.new(:knight, 'G1') }
    let(:computer_pieces) { [chess_piece_class.new(:pawn, 'E2'), knight_piece, chess_piece_class.new(:king, 'E1')] }
    let(:opponent_pieces) { [chess_piece_class.new(:king, 'E8'), chess_piece_class.new(:queen, 'H3')] }

    before { allow(computer).to receive(:pieces).and_return(computer_pieces) }

    context 'when a chess piece can be captured' do
      it 'should return the piece that should be moved' do
        expect(computer.capture_move(opponent_pieces)[:piece]).to eq(knight_piece)
      end

      it 'should return the destination coordinate' do
        expected_destination = 'H3'
        expect(computer.capture_move(opponent_pieces)[:destination]).to eq(expected_destination)
      end
    end

    context 'when no chess piece can be captured' do
      before { knight_piece.update_position('F3') }

      it 'should return nil' do
        expect(computer.capture_move(opponent_pieces)).to eq(nil)
      end
    end

    context "when the computers' pieces are empty" do
      before { computer_pieces.clear }

      it 'should return nil' do
        expect(computer.capture_move(opponent_pieces)).to eq(nil)
      end
    end

    context 'when opponent_pieces are empty' do
      before { opponent_pieces.clear }

      it 'should return nil' do
        expect(computer.capture_move(opponent_pieces)).to eq(nil)
      end
    end
  end

