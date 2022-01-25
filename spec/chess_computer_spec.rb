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

  describe '#defensive_move' do
    let(:pawn_piece) { chess_piece_class.new(:pawn, 'D2') }
    let(:computer_pieces) { [pawn_piece, chess_piece_class.new(:king, 'E1')] }
    let(:opponent_pieces) { [chess_piece_class.new(:queen, 'G5'), chess_piece_class.new(:king, 'E8')] }

    before { allow(computer).to receive(:pieces).and_return(computer_pieces) }

    context 'when a chess piece is under attack' do
      context 'when the chess piece can retreat to a safe coordinate' do
        it 'should return the piece that should be moved' do
          expect(computer.defensive_move(opponent_pieces)[:piece]).to eq(pawn_piece)
        end

        it 'should return the destination coordinate' do
          expected_destinations = %w[D3 D4]
          destination = computer.defensive_move(opponent_pieces)[:destination]

          expect(expected_destinations).to include(destination)
        end
      end

      context 'when the chess piece cannot retreat to a safe coordinate' do
        before { opponent_pieces.first.update_position('D8') }

        it 'should return nil' do
          expect(computer.defensive_move(opponent_pieces)).to eq(nil)
        end
      end
    end

    context 'when no chess piece is under attack' do
      before { pawn_piece.update_position('D3') }

      it 'should return nil' do
        expect(computer.defensive_move(opponent_pieces)).to eq(nil)
      end
    end

    context "when the computers' pieces are empty" do
      before { computer_pieces.clear }

      it 'should return nil' do
        expect(computer.defensive_move(opponent_pieces)).to eq(nil)
      end
    end

    context 'when opponent_pieces are empty' do
      before { opponent_pieces.clear }

      it 'should return nil' do
        expect(computer.defensive_move(opponent_pieces)).to eq(nil)
      end
    end
  end

  describe '#safe_move' do
    let(:king_piece) { chess_piece_class.new(:king, 'E1') }
    let(:opponent_king) { chess_piece_class.new(:king, 'E8') }

    context 'when a chess piece can move to a safe coordinate' do
      let(:computer_pieces) { [chess_piece_class.new(:knight, 'G1'), king_piece] }
      let(:opponent_pieces) { [chess_piece_class.new(:rook, 'C3'), chess_piece_class.new(:queen, 'A2'), opponent_king] }

      before { allow(computer).to receive(:pieces).and_return(computer_pieces) }

      it 'should return the piece that should be moved' do
        expect(computer.safe_move(opponent_pieces)[:piece]).to eq(king_piece)
      end

      it 'should return the destination coordinate' do
        expected_destinations = %w[F1 D1]
        destination = computer.safe_move(opponent_pieces)[:destination]

        expect(expected_destinations).to include(destination)
      end
    end

    context 'when a chess piece cannot move to a safe coordinate' do
      let(:computer_pieces) { [chess_piece_class.new(:pawn, 'E2'), king_piece] }
      let(:opponent_pieces) { [chess_piece_class.new(:rook, 'F4'), chess_piece_class.new(:queen, 'D4'), opponent_king] }

      before { allow(computer).to receive(:pieces).and_return(computer_pieces) }

      it 'should return nil' do
        expect(computer.safe_move(opponent_pieces)).to eq(nil)
      end
    end

    context "when the computers' pieces are empty" do
      let(:computer_pieces) { [] }
      let(:opponent_pieces) { [chess_piece_class.new(:pawn, 'D7'), opponent_king] }

      it 'should return nil' do
        expect(computer.defensive_move(opponent_pieces)).to eq(nil)
      end
    end

    context 'when opponent_pieces are empty' do
      let(:computer_pieces) { [chess_piece_class.new(:bishop, 'H6'), king_piece] }
      let(:opponent_pieces) { [] }

      it 'should return nil' do
        expect(computer.defensive_move(opponent_pieces)).to eq(nil)
      end
    end
  end

  describe '#random_move' do
    let(:queen_piece) { chess_piece_class.new(:queen, 'E2') }
    let(:king_piece) { chess_piece_class.new(:king, 'E1') }
    let(:computer_pieces) { [queen_piece, king_piece] }
    let(:opponent_pieces) { [chess_piece_class.new(:queen, 'E4'), chess_piece_class.new(:king, 'E8')] }

    before { allow(computer).to receive(:pieces).and_return(computer_pieces) }

    it 'should return the piece that should be moved' do
      expected_pieces = [queen_piece, king_piece]
      piece = computer.random_move(opponent_pieces)[:piece]

      expect(expected_pieces).to include(piece)
    end

    it 'should return the destination coordinate' do
      destination = computer.random_move(opponent_pieces)[:destination]
      expected_destinations = %w[F3 G4 H5 F2 G2 H2 F1 D1 D2 C2 B2 A2 D3 C4 B5 A6 E3 E4]

      expect(expected_destinations).to include(destination)
    end

    context "when the computers' pieces are empty" do
      before { computer_pieces.clear }

      it 'should return nil' do
        expect(computer.random_move(opponent_pieces)).to eq(nil)
      end
    end

    context 'when opponent_pieces are empty' do
      before { opponent_pieces.clear }

      it 'should return the piece that should be moved' do
        expected_pieces = [queen_piece, king_piece]
        piece = computer.random_move(opponent_pieces)[:piece]

        expect(expected_pieces).to include(piece)
      end

      it 'should return the destination coordinate' do
        destination = computer.random_move(opponent_pieces)[:destination]
        expected_destinations = %w[F3 G4 H5 F2 G2 H2 F1 D1 D2 C2 B2 A2 D3 C4 B5 A6 E3 E4 E5 E6 E7 E8]

        expect(expected_destinations).to include(destination)
      end
    end
  end
end
