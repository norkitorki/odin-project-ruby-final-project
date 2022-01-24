# frozen-string-literal: true

require_relative '../lib/chess'
require_relative '../lib/pathable'
require_relative '../lib/chess_player'
require_relative '../lib/chess_board'
require_relative '../lib/chess_computer'

describe Chess do
  let(:chess_piece_class) { ChessPiece }
  let(:player_class) { ChessPlayer }
  let(:player1) { instance_double(player_class, name: 'Player1') }
  let(:player2) { instance_double(player_class, name: 'Player2') }
  let(:chess_board) { instance_double(ChessBoard) }
  let(:computer) { instance_double(ChessComputer) }
  subject(:chess) { described_class.new(player1, player2, chess_board, computer) }

  describe '#play' do
    before do
      allow(chess).to receive(:reset)
      allow(chess).to receive(:main_menu)
    end

    it 'should reset the game' do
      expect(chess).to receive(:reset)

      chess.play
    end

    it 'should return to the main menu' do
      expect(chess).to receive(:main_menu)

      chess.play
    end
  end

  describe '#move' do
    context 'when a game ending condition has been met' do
      before { allow(chess).to receive(:game_over?).and_return(true) }

      it 'should send a call to #post_game and return' do
        expect(chess).to receive(:post_game)

        chess.move
      end
    end

    context 'when no game ending condition has been met' do
      before do
        allow(chess).to receive(:game_over?).and_return(false, true)
        allow(chess).to receive(:computer_move)
        allow(chess).to receive(:player_move)
        allow(chess).to receive(:update_board)
        allow(chess).to receive(:post_turn_update)
        allow(chess).to receive(:post_game)
      end

      context 'when the active_player is the computer' do
        before { allow(chess).to receive(:active_player).and_return(computer) }

        it 'should send a call to #computer_move' do
          expect(chess).to receive(:computer_move)

          chess.move
        end
      end

      context 'when the active_player is a player' do
        before { allow(chess).to receive(:active_player).and_return(player1) }

        it 'should send a call to #player_move' do
          reverted = false
          expect(chess).to receive(:player_move).with(reverted)

          chess.move(reverted: reverted)
        end

        context 'when reverted is true' do
          it 'should send a call to #player_move with true' do
            reverted = true
            expect(chess).to receive(:player_move).with(reverted)

            chess.move(reverted: reverted)
          end
        end
      end
    end
  end

  describe '#reset' do
    before do
      allow(player1).to receive(:reset)
      allow(player2).to receive(:reset)
      allow(chess_piece_class).to receive(:setup_pieces)
      allow(chess).to receive(:update_board)
    end

    it 'should reset @turn to 1' do
      expect { chess.reset }.to change { chess.turn }.to(1)
    end

    it 'should reset the players' do
      expect(player1).to receive(:reset).once
      expect(player2).to receive(:reset).once

      chess.reset
    end

    it 'should reset the chess pieces for each player' do
      white_pieces = described_class::WHITE_PIECES
      black_pieces = described_class::BLACK_PIECES
      expect(chess_piece_class).to receive(:setup_pieces).with(player1, white_pieces, :white).once
      expect(chess_piece_class).to receive(:setup_pieces).with(player2, black_pieces, :black).once

      chess.reset
    end

    it 'should reset @active_player to player1' do
      expect { chess.reset }.to change { chess.active_player }.to(player1)
    end

    it 'should reset the chess board' do
      expect(chess).to receive(:update_board).with(reset: true)

      chess.reset
    end
  end

  describe '#input' do
    before do
      allow(chess).to receive(:print)
      allow(chess).to receive(:gets).and_return('pawn', 'knight', 'queen')
    end

    it 'should request input from the user and return once the options includes the input' do
      options = %w[king queen bishop]
      expect(chess.input(options)).to eq('queen')
    end

    context 'when the optional conversion argument is passed' do
      it 'should call the user input with the conversion' do
        options = %w[KING QUEEN BISHOP]
        conversion = :upcase
        expect(chess.input(options, conversion)).to eq('QUEEN')
      end
    end
  end

  describe '#save' do
    before do
      allow(chess).to receive(:savegames).and_return([])
      allow(chess).to receive(:delete_oldest_save)
      allow(Dir).to receive(:mkdir)
      allow(chess).to receive(:active_player).and_return(player1)
      allow(YAML).to receive(:dump)
      allow(chess).to receive(:save_data)
      allow(chess).to receive(:save_to_file)
    end

    it 'should send a call to #save_to_file' do
      expect(chess).to receive(:save_to_file)

      chess.save
    end

    context 'when savegames.length >= MAX_SAVES_COUNT' do
      before { allow(chess).to receive(:savegames).and_return(Array.new(11)) }

      it 'should send a call to delete_oldest_save' do
        expect(chess).to receive(:delete_oldest_save)

        chess.save
      end
    end

    context 'when savegames.length < MAX_SAVES_COUNT' do
      before { allow(chess).to receive(:savegames).and_return(Array.new(3)) }

      it 'should not send a call to delete_oldest_save' do
        expect(chess).not_to receive(:delete_oldest_save)

        chess.save
      end
    end

    context 'when the savegame directory exists' do
      before { allow(Dir).to receive(:exist?).and_return(true) }

      it 'should not create the directory' do
        save_directory = Chess::SAVES_DIR
        expect(Dir).not_to receive(:mkdir).with(save_directory)

        chess.save
      end
    end

    context 'when the savegame directory does not exist' do
      before { allow(Dir).to receive(:exist?).and_return(false) }

      it 'should create the directory' do
        save_directory = Chess::SAVES_DIR
        expect(Dir).to receive(:mkdir).with(save_directory)

        chess.save
      end
    end
  end

  describe '#load' do
    let(:save_file) { './spec/save_files/save_file.save' }

    it 'should update @active_player' do
      expect { chess.load(save_file) }.to change { chess.active_player }
    end

    it 'should update @player1' do
      expect(chess.player1).to receive(:instance_variable_set).at_least(1).time

      chess.load(save_file)
    end

    it 'should update @player2' do
      expect(chess.player2).to receive(:instance_variable_set).at_least(1).time

      chess.load(save_file)
    end

    it 'should update @turn' do
      permitted_classes = described_class::PERMITTED_CLASSES
      loaded_turn = YAML.load_file(save_file, permitted_classes: permitted_classes)[:turn]
      expect { chess.load(save_file) }.to change { chess.turn }.to(loaded_turn)
    end
  end

  describe '#game_over?' do
    before do
      allow(chess).to receive(:active_player).and_return(player1)
      allow(chess).to receive(:opponent).and_return(player2)
      allow(player1).to receive(:pieces)
      allow(player2).to receive(:pieces)
      allow(chess_piece_class).to receive(:stalemate?).and_return(false)
      allow(chess_piece_class).to receive(:dead_position?).and_return(false)
    end

    context 'when the game ends in a stalemate' do
      before { allow(chess_piece_class).to receive(:stalemate?).and_return(true) }

      it 'should return true' do
        expect(chess).to be_game_over
      end
    end

    context 'when the game ends in a dead position' do
      before { allow(chess_piece_class).to receive(:dead_position?).and_return(true) }

      it 'should return true' do
        expect(chess).to be_game_over
      end
    end

    context 'when a player is checkmated' do
      before { allow(chess).to receive(:checkmate?).and_return(true) }

      it 'should return true' do
        expect(chess).to be_game_over
      end
    end
  end

  describe '#checkmate?' do
    let(:king_array) { [instance_double(chess_piece_class)] }

    before do
      allow(chess).to receive(:active_player).and_return(player1)
      allow(player1).to receive(:king).and_return(king_array)
      allow(player1).to receive(:pieces)
      allow(player2).to receive(:pieces)
    end

    context "when the current players' king is checkmated" do
      before { allow(king_array.first).to receive(:checkmate?).and_return(true) }

      it 'should return true' do
        expect(chess).to be_checkmate
      end
    end

    context "when the current players' king is not checkmated" do
      before { allow(king_array.first).to receive(:checkmate?).and_return(false) }

      it 'should return false' do
        expect(chess).to_not be_checkmate
      end
    end
  end
end
