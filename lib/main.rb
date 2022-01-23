# frozen-string-literal: true

require_relative 'chess'
require_relative 'chess_player'
require_relative 'chess_board'
require_relative 'chess_computer'

PLAYER1     = ChessPlayer.new('Player1')
PLAYER2     = ChessPlayer.new('Player2')
CHESS_BOARD = ChessBoard.new
COMPUTER    = ChessComputer.new('Computer')

CHESS = Chess.new(PLAYER1, PLAYER2, CHESS_BOARD, COMPUTER).play
