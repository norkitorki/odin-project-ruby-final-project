# frozen-string-literal: true

require_relative 'chess_piece'
require_relative 'pieces_setup'
require_relative 'messageable'
require_relative 'pathable'
require_relative 'chess_input'
require_relative 'resumable'

# bash shell chess game
class Chess
  include Messageable
  include Pathable
  include ChessInput
  include Resumable

  attr_reader :player1, :player2, :chess_board, :computer, :turn, :active_player

  WHITE_PIECES = { pawn: '🨅', rook: '🨂', knight: '🨄', bishop: '🨃',
                   queen: '🨁', king: '🨀' }.freeze

  BLACK_PIECES = WHITE_PIECES.transform_values { |s| "\e[30m#{s} \e[0m" }

  def initialize(player1, player2, chess_board, computer = nil)
    @player1 = player1
    @player2 = player2
    @chess_board = chess_board
    @computer = computer
  end

  def play
    reset
    main_menu
  end

  def move(reverted: false)
    until game_over?
      active_player == computer ? computer_move : player_move(reverted) || return
      update_board && post_turn_update && reverted = false
    end
    post_game
  end

  def reset
    @turn = 1
    [player1, player2].each(&:reset)
    ChessPiece.setup_pieces(player1, WHITE_PIECES, :white)
    ChessPiece.setup_pieces(player2, BLACK_PIECES, :black)
    @active_player = player1
    @previous_move = nil
    update_board(reset: true)
  end

  def game_over?
    player_pieces = active_player.pieces
    opponent_pieces = opponent.pieces
    ChessPiece.stalemate?(player_pieces, opponent_pieces) ||
      ChessPiece.dead_position?(player_pieces, opponent_pieces) || checkmate?
  end

  def checkmate?
    king = active_player.king.first
    king.checkmate?(active_player.pieces, opponent.pieces)
  end

  private

  def player_move(reverted)
    (clear && (piece = piece_input(reverted)) && clear) || return
    initial_position = piece.position
    destination = destination_input(piece) || return
    piece.update_position(destination)
    promote_pawn(piece) if piece.promotable?
    save_previous_move(piece, initial_position)
  end

  def promote_pawn(pawn)
    symbols = pawn.color == :white ? WHITE_PIECES : BLACK_PIECES
    pawn.promote(active_player, symbols)
  end

  def computer_move
    move = computer.move(player1.pieces)
    piece = move[:piece]
    initial_position = piece.position
    destination = move[:destination]
    piece.update_position(destination)
    computer.capture(player1.remove_piece(destination))
    computer_promotion(piece) if piece.promotable?
    save_previous_move(piece, initial_position)
  end

  def computer_promotion(pawn)
    position = pawn.position
    computer.remove_piece(position)
    new_piece = pawn.class.new(:queen, position, BLACK_PIECES[:queen], color: :black)
    computer.add_piece(new_piece)
  end

  def save_previous_move(piece, initial_position)
    capture = active_player.find_piece_by(:position, piece.position, active_player.captures)
    hash = { piece: piece, initial_position: initial_position, capture: capture }
    @previous_move = hash
  end

  def update_board(reset: false)
    chess_board.clear(reset: reset)
    pieces = (player1.pieces + player2.pieces)
    pieces.each { |piece| chess_board.place(piece.position, piece.symbol) }
  end

  def post_turn_update
    chess_board.invert
    @active_player = opponent
    @turn += 1
  end

  def save_game
    save
    puts game_saved_message(savegames.last)
    sleep 3
    main_menu
  end

  def opponent(player = active_player)
    player == player1 ? player2 : player1
  end

  def clear
    system('clear')
  end
end
