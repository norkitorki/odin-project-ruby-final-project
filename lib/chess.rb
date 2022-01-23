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

  def reset
    @turn = 1
    [player1, player2].each(&:reset)
    ChessPiece.setup_pieces(player1, WHITE_PIECES, :white)
    ChessPiece.setup_pieces(player2, BLACK_PIECES, :black)
    @active_player = player1
    update_board(reset: true)
  end

  def play
    reset
    main_menu
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

  def move(reverted: false)
    until game_over?
      clear
      piece = piece_input(reverted) || return
      clear
      destination = destination_input(piece) || return
      piece.update_position(destination)
      promote_pawn(piece) if piece.promotable?
      update_board && post_turn_update && reverted = false
    end
    post_game
  end

  private

  def promote_pawn(pawn)
    symbols = pawn.color == :white ? WHITE_PIECES : BLACK_PIECES
    pawn.promote(active_player, symbols)
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
