# frozen-string-literal: true

# console input for chess game
module ChessInput
  def input(options, conversion = nil)
    print '=> '
    input = gets.chomp.send(conversion || :to_s)
    options.any?(input) ? input : input(options, conversion)
  end

  def main_menu
    system('clear')
    puts main_menu_message
    command = input(%w[b black c computer e exit l load r reset s save start w white])
    return assign_player(command) if command.start_with?(/b|w/)
    return assign_computer if command.start_with?('c')
    return save_game if command == 'save'
    return load_game if command.start_with?('l')
    return if command.start_with?('e')

    reset if command.start_with?('r')
    move
  end

  private

  def assign_player(color)
    puts 'Please input a name:'
    (color.start_with?('w') ? player1 : player2).name = gets.chomp
    play
  end

  def assign_computer
    return main_menu unless computer

    if player2 == computer
      @player2 = @initial_player2
    else
      @initial_player2 = player2
      @player2 = computer
    end
    play
  end

  def load_game
    saves = savegames
    return play if saves.empty?

    puts select_save_game_message
    index = input(('1'..saves.length.to_s).to_a << 'c', :downcase).to_i - 1
    filepath = "#{Resumable::SAVES_DIR}#{saves[index]}"
    index == 'c' ? play : load(filepath) && move
  end

  def piece_input(reverted)
    puts move_opening_message(active_player.pieces, opponent.pieces, reverted)
    position = input(active_player.pieces(:position) + %w[E EXIT], :upcase)
    active_player.find_piece_by(:position, position) || main_menu
  end

  def destination_input(piece)
    player_pieces = active_player.pieces
    moveset = piece.moveset(player_pieces, opponent.pieces)
    display_path(moveset, chess_board)
    return puts empty_moveset_message(piece) && move if moveset.empty?

    choose_destination(piece, moveset, player_pieces)
  end

  def choose_destination(piece, moveset, player_pieces)
    puts piece_movement_message(piece, moveset)
    destination = input(moveset << 'C', :upcase)
    revert = position_checked?(active_player, piece, destination)
    return move(reverted: revert) if destination == 'C' || revert

    capture_piece(destination)
    piece.castle(player_pieces, destination) if piece.castling?(destination)
    destination
  end

  def position_checked?(player, piece, position)
    !piece.legal_move?(player.pieces, opponent(player).pieces, position)
  end

  def capture_piece(destination)
    opponent_piece = opponent.remove_piece(destination)
    active_player.capture(opponent_piece) if opponent_piece
  end

  def post_game
    puts chess_board
    puts post_game_message
    puts "\nInput 'c' to return to the main menu..."
    input(['c'], :downcase) && play
  end

  def post_game_message
    p_pieces = active_player.pieces
    o_pieces = opponent.pieces

    return stalemate_message(turn) if ChessPiece.stalemate?(p_pieces, o_pieces)
    return dead_draw_message(turn) if ChessPiece.dead_position?(p_pieces, o_pieces)

    check_mate_message(opponent, turn)
  end
end
