# frozen-string-literal: true

require_relative '../lib/chess_player'

describe ChessPlayer do
  subject(:chess_player) { described_class.new('John') }

  describe '#add_piece' do
    context 'when the piece.type is a valid chess piece' do
      context 'when the piece.type is :queen' do
        subject(:queen_piece) { double('QueenPiece', type: :queen) }

        it 'should add the piece the the queen pieces' do
          expect { chess_player.add_piece(queen_piece) }.to change { chess_player.queen }.from([]).to([queen_piece])
        end
      end

      context 'when the piece.type is :pawn' do
        subject(:pawn_piece) { double('PawnPiece', type: :pawn) }

        it 'should add the piece th the pawn pieces' do
          expect { chess_player.add_piece(pawn_piece) }.to change { chess_player.pawn }.from([]).to([pawn_piece])
        end
      end

      context 'when there is already a piece of the same type present' do
        subject(:a_rook_piece) { double('a_rook', type: :rook) }
        subject(:h_rook_piece) { double('h_rook', type: :rook) }

        before { chess_player.add_piece(a_rook_piece) }

        it 'should add the second piece' do
          expect { chess_player.add_piece(h_rook_piece) }.to change { chess_player.rook }.from([a_rook_piece]).to([a_rook_piece, h_rook_piece])
        end
      end
    end

    context 'when the piece.type is not a valid chess piece' do
      subject(:duchess_piece) { double('DuchessPiece', type: :duchess) }

      it 'should not add the piece' do
        expect { chess_player.add_piece(duchess_piece) }.to_not change { chess_player }
      end

      it 'should return nil' do
        expect(chess_player.add_piece(duchess_piece)).to eq(nil)
      end
    end
  end

  describe '#remove_piece' do
    context 'when a chess piece with the passed in position exists' do
      let(:position) { 'C1' }
      subject(:bishop_piece) { double('BishopPiece', type: :bishop, position: position) }

      before { chess_player.instance_variable_set(:@bishop, [bishop_piece]) }

      it 'should remove the piece' do
        expect { chess_player.remove_piece(position) }.to change { chess_player.bishop }.from([bishop_piece]).to([])
      end

      it 'should return the piece' do
        expect(chess_player.remove_piece(position)).to eq(bishop_piece)
      end
    end

    context 'when a chess piece with the passed in position does not exist' do
      let(:position) { 'B7' }
      subject(:bishop_piece) { double('KnightPiece', type: :knight, position: position) }

      it 'should not remove any piece' do
        expect { chess_player.remove_piece(position) }.not_to change { chess_player }
      end

      it 'should return nil' do
        expect(chess_player.remove_piece(position)).to eq(nil)
      end
    end
  end

  describe '#pieces' do
    context 'when no attribute is passed in' do
      let(:pawn_pieces) { 3.times.map { double('PawnPiece') } }
      let(:king_pieces) { [double('KingPiece')] }

      before do
        chess_player.instance_variable_set(:@pawn, pawn_pieces)
        chess_player.instance_variable_set(:@king, king_pieces)
      end

      it 'should return an array with all chess pieces' do
        expected_pieces = pawn_pieces + king_pieces
        expect(chess_player.pieces).to eq(expected_pieces)
      end
    end

    context 'when an attribute is passed in' do
      let(:positions) { %w[A1 H1 B1 G1] }
      let(:rook_pieces) { (0..1).map { |i| double('RookPiece', position: positions[i]) } }
      let(:knight_pieces) { (2..3).map { |i| double('KnightPiece', position: positions[i]) } }

      before do
        chess_player.instance_variable_set(:@rook, rook_pieces)
        chess_player.instance_variable_set(:@knight, knight_pieces)
      end

      it "it should return an array with the pieces' attributes" do
        attribute = :position
        expect(chess_player.pieces(attribute)).to eq(positions)
      end

      context 'when no chess piece has a corresponding attribute' do
        it 'should return an empty array' do
          attribute = :color
          expect(chess_player.pieces(attribute)).to eq([])
        end
      end

      context 'when there are no chess pieces' do
        before do
          chess_player.instance_variable_set(:@rook, [])
          chess_player.instance_variable_set(:@knight, [])
        end

        it 'should return an empty array' do
          attribute = :position
          expect(chess_player.pieces(attribute)).to eq([])
        end
      end
    end
  end

  describe '#reset' do
    it 'should clear all piece arrays' do
      described_class::PIECES.each do |var|
        expect(chess_player).to receive(:instance_variable_set).with(var, [])
      end

      chess_player.reset
    end
  end

  describe '#find_piece_by' do
    let(:pawn_pieces) { [double('PawnPiece', position: 'D2')] }
    let(:king_pieces) { [double('KingPiece', position: 'E1')] }

    before do
      chess_player.instance_variable_set(:@pawn, pawn_pieces)
      chess_player.instance_variable_set(:@king, king_pieces)
    end

    context 'when a chess piece responds to the attribute' do
      context "when the attributes' value matches the passed in value" do
        it 'should return the first matched chess piece' do
          attribute = :position
          value = 'E1'
          expect(chess_player.find_piece_by(attribute, value)).to eq(king_pieces.first)
        end
      end

      context "when no attributes' value matches the passed in value" do
        it 'should return nil' do
          attribute = :position
          value = 'H3'
          expect(chess_player.find_piece_by(attribute, value)).to eq(nil)
        end
      end
    end

    context 'when no chess piece responds to the attribute' do
      it 'should return nil' do
        attribute = :file
        value = 'F'
        expect(chess_player.find_piece_by(attribute, value)).to eq(nil)
      end
    end

    context 'when optional pieces are passed in' do
      let(:piece_array) { ('A'..'C').map { |s| double('PawnPiece', position: "#{s}2") } }

      it 'should use the passed in pieces' do
        attribute = :position
        value = 'B2'
        expect(chess_player.find_piece_by(attribute, value, piece_array)).to eq(piece_array[1])
      end
    end
  end

  describe '#capture' do
    subject(:captured_piece) { double('ChessPiece') }

    it "should add a chess piece to the players' captures" do
      expect { chess_player.capture(captured_piece) }.to change { chess_player.captures }.from([]).to([captured_piece])
    end
  end

  describe '#piece?' do
    it 'should send a call to #find_piece_by' do
      attribute = :symbol
      value = '🨃'
      pieces = chess_player.pieces
      expect(chess_player).to receive(:find_piece_by).with(attribute, value, pieces).and_return(nil)

      chess_player.capture?(attribute, value)
    end
  end

  describe '#capture?' do
    it 'should send a call to #find_piece_by' do
      attribute = :rank
      value = '4'
      captures = chess_player.captures
      expect(chess_player).to receive(:find_piece_by).with(attribute, value, captures).and_return(nil)

      chess_player.capture?(attribute, value)
    end
  end
end
