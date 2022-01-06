# frozen-string-literal: true

require_relative '../lib/chess_piece'

describe ChessPiece do
  let(:empty_pieces) { [] }

  describe '.setup_pieces' do
    let(:player_pieces) { { pawn: '🨅', rook: '🨂', knight: '🨄', bishop: '🨃', queen: '🨁', king: '🨀' } }
    let(:player) { double('ChessPlayer') }

    before { allow(player).to receive(:add_piece) }

    it 'should add the chess pieces to the player' do
      expect(player).to receive(:add_piece).exactly(16).times

      described_class.setup_pieces(player, player_pieces, :white)
    end
  end

  describe '.stalemate?' do
    context "when the players' is not in check and has no legal moves" do
      let(:player_pieces) { [described_class.new(:king, 'H8')] }
      let(:opponent_pieces) { [described_class.new(:queen, 'G6'), described_class.new(:king, 'F7')] }

      it 'should return true' do
        expect(described_class.stalemate?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context "when the players' king is in check" do
      let(:player_pieces) { [described_class.new(:king, 'F8')] }
      let(:opponent_pieces) { [described_class.new(:queen, 'F7'), described_class.new(:king, 'F6')] }

      it 'should return false' do
        expect(described_class.stalemate?(player_pieces, opponent_pieces)).to eq(false)
      end
    end

    context "when the player is not in check" do
      let(:player_pieces) { [described_class.new(:king, 'E8')] }
      let(:opponent_pieces) { [described_class.new(:queen, 'H6'), described_class.new(:king, 'F6')] }

      it 'should return false' do
        expect(described_class.stalemate?(player_pieces, opponent_pieces)).to eq(false)
      end
    end
  end

  describe '.dead_position?' do
    context 'when both players only have a king' do
      let(:player_pieces) { [described_class.new(:king, 'E1')] }
      let(:opponent_pieces) { [described_class.new(:king, 'E8')] }

      it 'should return true' do
        expect(described_class.dead_position?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context "when the players' king is up against a king and a bishop" do
      let(:player_pieces) { [described_class.new(:king, 'E1')] }
      let(:opponent_pieces) { [described_class.new(:bishop, 'C4'), described_class.new(:king, 'E4')] }

      it 'should return true' do
        expect(described_class.dead_position?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context "when the players' king is up against a king and a knight" do
      let(:player_pieces) { [described_class.new(:king, 'E1')] }
      let(:opponent_pieces) { [described_class.new(:knight, 'H6'), described_class.new(:king, 'G5')] }

      it 'should return true' do
        expect(described_class.dead_position?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context "when no dead position has been reached" do
      let(:player_pieces) { [described_class.new(:king, 'E1'), described_class.new(:bishop, 'E2')] }
      let(:opponent_pieces) { [described_class.new(:queen, 'A5'), described_class.new(:king, 'B5')] }

      it 'should return false' do
        expect(described_class.dead_position?(player_pieces, opponent_pieces)).to eq(false)
      end
    end
  end

  describe '#update_position' do
    subject(:queen_piece) { described_class.new(:queen) }

    context 'when the coordinate is a valid chess coordinate' do
      let(:coordinate) { 'D1' }

      it 'should update the file' do
        file = 'D'
        expect { queen_piece.update_position(coordinate) }.to change { queen_piece.file }.to(file)
      end

      it 'should update the rank' do
        rank = '1'
        expect { queen_piece.update_position(coordinate) }.to change { queen_piece.rank }.to(rank)
      end

      context 'when optional piece_moved: argument is true' do
        it 'should update @moved to true' do
          expect { queen_piece.update_position(coordinate) }.to change { queen_piece.moved? }.to(true)
        end
      end

      context 'when optional piece_moved: argument is false' do
        it 'should not update @moved' do
          expect { queen_piece.update_position(coordinate, piece_moved: false) }.not_to change { queen_piece.moved? }
        end
      end

      it 'should update the position' do
        expect { queen_piece.update_position(coordinate) }.to change { queen_piece.position }.to(coordinate)
      end
    end

    context 'when the coordinate is not a valid chess coordinate' do
      let(:invalid_coordinate) { 'D12' }

      it 'should not update the file' do
        file = 'D'
        expect { queen_piece.update_position(invalid_coordinate) }.not_to change { queen_piece.file }
      end

      it 'should not update the rank' do
        rank = '1'
        expect { queen_piece.update_position(invalid_coordinate) }.not_to change { queen_piece.rank }
      end

      it 'should not update @moved' do
        expect { queen_piece.update_position(invalid_coordinate) }.not_to change { queen_piece.moved? }
      end

      it 'should not update the position' do
        expect { queen_piece.update_position(invalid_coordinate) }.not_to change { queen_piece.position }
      end
    end
  end

  describe '#moveset' do
    context 'when the type is :pawn' do
      let(:pawn_type) { :pawn }
      subject(:white_pawn) { described_class.new(pawn_type, 'D2') }

      context 'when the pawn is a white pawn' do
        context "when the pawn has not been moved" do
          it 'should return the next possible moves' do
            expected_moves = %w[D3 D4]
            expect(white_pawn.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
          end
        end

        context "when the pawn has been moved" do
          before { white_pawn.update_position('D4') }

          it 'should return the next possible move' do
            expected_moves = %w[D5]
            expect(white_pawn.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
          end
        end
      end

      context 'when the pawn is a black pawn' do
        subject(:black_pawn) { described_class.new(pawn_type, 'D7', color: :black) }

        context 'when the pawn has not been moved' do
          it 'should return the next possible moves' do
            expected_moves = %w[D6 D5]
            expect(black_pawn.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
          end
        end

        context 'when the pawn has been moved' do
          before { black_pawn.update_position('D5') }

          it 'should return the next possible moves' do
            expected_moves = %w[D4]
            expect(black_pawn.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
          end
        end
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(:queen, 'D4')] }

        it 'should return the next possible moves' do
          expected_moves = %w[D3]
          expect(white_pawn.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        context 'when the optional color argument is :white' do
          let(:opponent_pieces) { [described_class.new(pawn_type, 'C3'), described_class.new(pawn_type, 'E3')] }

          before { white_pawn.instance_variable_set(:@moved, true) }

          it 'should return the next possible moves' do
            expected_moves = %w[D3 C3 E3]
            expect(white_pawn.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
          end
        end
      end
    end

    context 'when the type is :rook' do
      let(:rook_type) { :rook }
      subject(:rook) { described_class.new(rook_type, 'F4') }

      it 'should return the next possible moves' do
        expected_moves = %w[G4 H4 F3 F2 F1 E4 D4 C4 B4 A4 F5 F6 F7 F8]
        expect(rook.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(rook_type, 'H4'), described_class.new(rook_type, 'F6')] }

        it 'should return the next possible moves' do
          expected_moves = %w[G4 F3 F2 F1 E4 D4 C4 B4 A4 F5]
          expect(rook.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        let(:opponent_pieces) { [described_class.new(rook_type, 'D4'), described_class.new(rook_type, 'F3')] }

        it 'should return the next possible moves' do
          expected_moves = %w[G4 H4 F3 E4 D4 F5 F6 F7 F8]
          expect(rook.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
        end
      end
    end

    context 'when the type is :knight' do
      let(:knight_type) { :knight }
      subject(:knight) { described_class.new(knight_type, 'B3') }

      it 'should return the next possible moves' do
        expected_moves = %w[C5 D4 D2 C1 A1 A5]
        expect(knight.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(knight_type, 'C5'), described_class.new(knight_type, 'A5')] }

        it 'should return the next possible moves' do
          expected_moves = %w[D4 D2 C1 A1]
          expect(knight.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        let(:opponent_pieces) { [described_class.new(knight_type, 'D2'), described_class.new(knight_type, 'A1')] }

        it 'should return the next possible moves' do
          expected_moves = %w[C5 D4 D2 C1 A1 A5]
          expect(knight.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
        end
      end
    end

    context 'when the type is :bishop' do
      let(:bishop_type) { :bishop }
      subject(:bishop) { described_class.new(bishop_type, 'E5') }

      it 'should return the next possible moves' do
        expected_moves = %w[F6 G7 H8 F4 G3 H2 D4 C3 B2 A1 D6 C7 B8]
        expect(bishop.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(bishop_type, 'G7'), described_class.new(bishop_type, 'D6')] }

        it 'should return the next possible moves' do
          expected_moves = %w[F6 F4 G3 H2 D4 C3 B2 A1]
          expect(bishop.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        let(:opponent_pieces) { [described_class.new(bishop_type, 'C3'), described_class.new(bishop_type, 'C7')] }

        it 'should return the next possible moves' do
          expected_moves = %w[F6 G7 H8 F4 G3 H2 D4 C3 D6 C7]
          expect(bishop.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
        end
      end
    end

    context 'when the type is :queen' do
      let(:queen_type) { :queen }
      subject(:queen) { described_class.new(queen_type, 'C7') }

      it 'should return the next possible moves' do
        expected_moves = %w[D8 D7 E7 F7 G7 H7 D6 E5 F4 G3 H2 C6 C5 C4 C3 C2 C1 B6 A5 B7 A7 B8 C8]
        expect(queen.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(queen_type, 'F7'), described_class.new(queen_type, 'E5')] }

        it 'should return the next possible moves' do
          expected_moves = %w[D8 D7 E7 D6 C6 C5 C4 C3 C2 C1 B6 A5 B7 A7 B8 C8]
          expect(queen.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        let(:opponent_pieces) { [described_class.new(queen_type, 'D8'), described_class.new(queen_type, 'C2')] }

        it 'should return the next possible moves' do
          expected_moves = %w[D8 D7 E7 F7 G7 H7 D6 E5 F4 G3 H2 C6 C5 C4 C3 C2 B6 A5 B7 A7 B8 C8]
          expect(queen.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
        end
      end
    end

    context 'when the type is :king' do
      let(:king_type) { :king }
      subject(:king) { described_class.new(king_type, 'E1') }

      it 'should return the next possible moves' do
        expected_moves = %w[F2 F1 D1 D2 E2]
        expect(king.moveset(empty_pieces, empty_pieces)).to match_array(expected_moves)
      end

      context 'when a player piece is placed at a coordinate in the moveset' do
        let(:player_pieces) { [described_class.new(king_type, 'F1'), described_class.new(king_type, 'D1')] }

        it 'should return the next possible moves' do
          expected_moves = %w[F2 D2 E2]
          expect(king.moveset(player_pieces, empty_pieces)).to match_array(expected_moves)
        end
      end

      context "when an opponents' piece is placed at a coordinate in the moveset" do
        let(:opponent_pieces) { [described_class.new(king_type, 'F2'), described_class.new(king_type, 'E2')] }

        it 'should return the next possible moves' do
          expected_moves = %w[F2 F1 D1 D2 E2]
          expect(king.moveset(empty_pieces, opponent_pieces)).to match_array(expected_moves)
        end
      end
    end
  end

  describe '#black_piece?' do
    context 'when the chess piece is a black piece' do
      subject(:black_knight) { described_class.new(:knight, 'B1', color: :black) }

      it 'should return true' do
        expect(black_knight).to be_black_piece
      end
    end

    context 'when the chess piece is a white piece' do
      subject(:white_knight) { described_class.new(:knight, 'B1', color: :white) }

      it 'should return false' do
        expect(white_knight).not_to be_black_piece
      end
    end
  end

  describe '#moved?' do
    subject(:bishop) { described_class.new(:bishop, 'C1') }

    context 'when the chess piece has been moved' do
      before { bishop.update_position('F4') }

      it 'should return true' do
        expect(bishop).to be_moved
      end
    end

    context 'when the chess piece has not been moved' do
      it 'should return false' do
        expect(bishop).not_to be_moved
      end
    end
  end

  describe '#promotable?' do
    context 'when the optional color argument is :white' do
      subject(:white_pawn) { described_class.new(:pawn, 'D2') }

      context 'when the pawn is promotable' do
        before { white_pawn.update_position('D8') }

        it 'should return true' do
          expect(white_pawn).to be_promotable
        end
      end

      context 'when the pawn is not promotable' do
        it 'should return false' do
          expect(white_pawn).not_to be_promotable
        end
      end
    end

    context 'when the optional color argument is :black' do
      subject(:black_pawn) { described_class.new(:pawn, 'D7', color: :black) }

      context 'when the pawn is promotable' do
        before { black_pawn.update_position('D1') }

        it 'should return true' do
          expect(black_pawn).to be_promotable
        end
      end

      context 'when the pawn is not promotable' do
        it 'should return false' do
          expect(black_pawn).not_to be_promotable
        end
      end
    end
  end

  describe '#promote' do
    subject(:pawn) { described_class.new(:pawn, 'A8') }
    let(:player) { double('ChessPlayer') }
    let(:symbols) { { rook: '🨂', knight: '🨄', bishop: '🨃', queen: '🨁' } }

    before do
      allow(pawn).to receive(:puts)
      allow(pawn).to receive(:gets).and_return('queen')
      allow(player).to receive(:add_piece)
      allow(player).to receive(:remove_piece)
    end

    it 'should initialize a new chess piece' do
      promotion_type = :queen
      expect(described_class).to receive(:new).with(promotion_type, pawn.position, symbols[promotion_type], color: pawn.color)

      pawn.promote(player, symbols)
    end

    it 'should add the new chess piece to the player' do
      expect(player).to receive(:add_piece)

      pawn.promote(player, symbols)
    end

    it 'should remove the promoted pawn from the player' do
      expect(player).to receive(:remove_piece).with(pawn.position)

      pawn.promote(player, symbols)
    end
  end

  describe '#check?' do
    subject(:king) { described_class.new(:king, 'E1') }

    context 'when the king is in check' do
      let(:player_pieces) { [king] }
      let(:opponent_pieces) { [described_class.new(:queen, 'E8')] }

      it 'should return true' do
        expect(king.check?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context 'when the king is not in check' do
      let(:player_pieces) { [king] }
      let(:opponent_pieces) { [described_class.new(:queen, 'H5')] }

      it 'should return false' do
        expect(king.check?(player_pieces, opponent_pieces)).to eq(false)
      end
    end
  end

  describe '#checkmate?' do
    subject(:king) { described_class.new(:king, 'E8', color: :black) }

    context 'when the king is checkmated' do
      let(:player_pieces) { [king] }
      let(:opponent_pieces) { [described_class.new(:queen, 'H8'), described_class.new(:rook, 'B7')] }

      it 'should return true' do
        expect(king.checkmate?(player_pieces, opponent_pieces)).to eq(true)
      end
    end

    context 'when the king is not checkmated' do
      let(:player_pieces) { [king] }
      let(:opponent_pieces) { [described_class.new(:queen, 'H5'), described_class.new(:knight, 'G8')] }

      it 'should return false' do
        expect(king.checkmate?(player_pieces, opponent_pieces)).to eq(false)
      end
    end
  end

  describe '#legal_move?' do
    subject(:player_queen) { described_class.new(:queen, 'D1') }
    let(:player_pieces) { [player_queen, described_class.new(:king, 'E1')] }
    let(:opponent_pieces) { [described_class.new(:rook, 'A1'), described_class.new(:king, 'B3')] }

    context "when the current players' king is not in check post move" do
      it 'should return true' do
        destination = 'C1'
        expect(player_queen.legal_move?(player_pieces, opponent_pieces, destination)).to eq(true)
      end
    end

    context "when the current players' king is in check post move" do
      it 'should return false' do
        destination = 'D3'
        expect(player_queen.legal_move?(player_pieces, opponent_pieces, destination)).to eq(false)
      end
    end
  end

  describe '#castleable?' do
    subject(:king) { described_class.new(:king, 'E1') }
    let(:a_rook) { described_class.new(:rook, 'A1') }
    let(:h_rook) { described_class.new(:rook, 'H1') }

    context 'when castling is permitted' do
      let(:player_pieces) { [a_rook, king] }

      it 'should return true' do
        expect(king.castleable?(player_pieces, empty_pieces, a_rook.position)).to eq(true)
      end
    end

    context 'when not called on a chess piece with type of :king' do
      let(:queen) { described_class.new(:queen, 'D1') }
      let(:player_pieces) { [h_rook, queen, king] }

      it 'should return false' do
        expect(queen.castleable?(player_pieces, empty_pieces, h_rook.position)).to eq(false)
      end
    end

    context 'when castling is not permitted' do
      let(:player_pieces) { [h_rook, king] }

      context "when the king is in check" do
        let(:opponent_rook) { described_class.new(:rook, 'E4', color: :black) }

        it 'should return false' do
          opponent_pieces = [opponent_rook]
          expect(king.castleable?(player_pieces, opponent_pieces, h_rook.position)).to eq(false)
        end
      end

      context 'when the king has previously been moved' do
        before { king.instance_variable_set(:@moved, true) }

        it 'should return false' do
            expect(king.castleable?(player_pieces, empty_pieces, h_rook.position)).to eq(false)
        end
      end

      context 'when the rook has previously been moved' do
        before { h_rook.instance_variable_set(:@moved, true) }

        it 'should return false' do
          expect(king.castleable?(player_pieces, empty_pieces, h_rook.position)).to eq(false)
        end
      end

      context 'when the squares between the king and rook are not empty' do
        before { player_pieces << described_class.new(:knight, 'G1') }

        it 'should return false' do
          expect(king.castleable?(player_pieces, empty_pieces, h_rook.position)).to eq(false)
        end
      end

      context 'when a square between the king and rook is under attack' do
        let(:opponent_pieces) { [described_class.new(:bishop, 'C5')] }

        it 'should return false' do
          expect(king.castleable?(player_pieces, opponent_pieces, h_rook.position)).to eq(false)
        end
      end
    end

    context 'when the king is a black king' do
      subject(:black_king) { described_class.new(:king, 'E8', color: :black) }

      context 'when castling is permitted' do
        let(:a_rook) { described_class.new(:rook, 'A8', color: :black) }
        let(:player_pieces) { [black_king, a_rook] }

        it 'should return true' do
          expect(black_king.castleable?(player_pieces, empty_pieces, a_rook.position)).to eq(true)
        end
      end

      context 'when castling is not permitted' do
        let(:h_rook) { described_class.new(:rook, 'H8', color: :black) }
        let(:player_pieces) { [black_king, h_rook] }
        let(:opponent_pieces) { [described_class.new(:rook, 'G1')] }

        it 'should return false' do
          expect(black_king.castleable?(player_pieces, opponent_pieces, h_rook.position)).to eq(false)
        end
      end
    end
  end

  describe '#castle_moveset' do
    context 'when the king is a white king' do
      subject(:white_king) { described_class.new(:king, 'E1') }
      let(:white_a_rook) { described_class.new(:rook, 'A1') }
      let(:white_h_rook) { described_class.new(:rook, 'H1') }
      let(:player_pieces) { [white_king, white_a_rook, white_h_rook] }

      it 'should return the castling coordinates for the king' do
        castling_moves = %w[C1 G1]
        expect(white_king.castle_moveset(player_pieces, empty_pieces)).to match_array(castling_moves)
      end
    end

    context 'when the king is a black king' do
      subject(:black_king) { described_class.new(:king, 'E8', color: :black) }
      let(:black_a_rook) { described_class.new(:rook, 'A8', color: :black) }
      let(:black_h_rook) { described_class.new(:rook, 'H8', color: :black) }
      let(:player_pieces) { [black_king, black_a_rook, black_h_rook] }

      it 'should return the castling coordinates for the king' do
        castling_moves = %w[C8 G8]
        expect(black_king.castle_moveset(player_pieces, empty_pieces)).to match_array(castling_moves)
      end
    end
  end

  describe '#castle' do
    context 'when the king is a white king' do
      subject(:white_king) { described_class.new(:king, 'E1') }

      context 'when castling the king and rook at A1' do
        let(:a1_rook) { described_class.new(:rook, 'A1') }
        let(:player_pieces) { [white_king, a1_rook] }

        it 'should castle the king and rook' do
          king_destination = 'C1'
          rook_destination = 'D1'
          expect { white_king.castle(player_pieces, king_destination) }.to change { white_king.position }.to(king_destination).and change { a1_rook.position }.to(rook_destination)
        end
      end

      context 'when castling the king and rook at H1' do
        let(:h1_rook) { described_class.new(:rook, 'H1') }
        let(:player_pieces) { [white_king, h1_rook] }

        it 'should castle the king and rook' do
          king_destination = 'G1'
          rook_destination = 'F1'
          expect { white_king.castle(player_pieces, king_destination) }.to change { white_king.position }.to(king_destination).and change { h1_rook.position }.to(rook_destination)
        end
      end
    end

    context 'when the king is a black king' do
      subject(:black_king) { described_class.new(:king, 'E8', color: :black) }

      context 'when castling the king and rook at A8' do
        let(:a8_rook) { described_class.new(:rook, 'A8') }
        let(:player_pieces) { [black_king, a8_rook] }

        it 'should castle the king and rook' do
          king_destination = 'C8'
          rook_destination = 'D8'
          expect { black_king.castle(player_pieces, king_destination) }.to change { black_king.position }.to(king_destination).and change { a8_rook.position }.to(rook_destination)
        end
      end

      context 'when castling the king and rook at H8' do
        let(:h8_rook) { described_class.new(:rook, 'H8') }
        let(:player_pieces) { [black_king, h8_rook] }

        it 'should castle the king and rook' do
          king_destination = 'G8'
          rook_destination = 'F8'
          expect { black_king.castle(player_pieces, king_destination) }.to change { black_king.position }.to(king_destination).and change { h8_rook.position }.to(rook_destination)
        end
      end
    end
  end
end
