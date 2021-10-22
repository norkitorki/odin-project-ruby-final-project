# frozen-string-literal: true

require_relative '../lib/chess_piece'

describe ChessPiece do
  subject(:chess_piece) { ChessPiece.new(unicode_queen) }
  let(:unicode_queen) { '🨁' }

  describe '#position=' do
    context 'when the coordinate is valid' do
      it 'should assign file' do
        valid_coordinate = 'H5'
        file = 'H'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.file }.to(file)
      end

      it 'should assign rank' do
        valid_coordinate = 'F8'
        rank = '8'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.rank }.to(rank)
      end

      it 'should assign position' do
        valid_coordinate = 'B1'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.position }.to(valid_coordinate)
      end
    end

    context 'when the coordinate is invalid' do
      before { allow(chess_piece).to receive(:puts).once }

      it 'should notify the user that the coordinate is invalid' do
        error_message = 'D10 is not a valid chess coordinate.'
        invalid_coordinate = 'D10'
        expect(chess_piece).to receive(:puts).with(error_message).once
        chess_piece.position = invalid_coordinate
      end

      it 'should not assign a position' do
        invalid_coordinate = '1023'
        expect { chess_piece.position = invalid_coordinate }.not_to change { chess_piece.position }
      end
    end
  end
end
