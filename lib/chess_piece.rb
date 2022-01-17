# frozen-string-literal: true

require_relative 'pieces_setup'
require_relative 'traversable'
require_relative 'checkable'
require_relative 'promotable'
require_relative 'castleable'
require_relative 'drawable'

# chess pieces for chess console game
class ChessPiece
  extend PiecesSetup
  extend Drawable
  include Traversable
  include Checkable
  include Promotable
  include Castleable

  TYPES = %i[pawn rook knight bishop queen king].freeze

  attr_reader :type, :position, :file, :rank, :symbol, :color

  def initialize(type, position = nil, symbol = nil, color: :white)
    return unless TYPES.include?(type)

    @type = type
    update_position(position, piece_moved: false) if position
    @symbol = symbol
    @moved = false
    @color = color
  end

  def update_position(coordinate, piece_moved: true)
    return unless valid_coordinate?(coordinate)

    @file = coordinate[0].upcase
    @rank = coordinate[1]
    @moved = true if piece_moved
    @position = coordinate
  end

  def moveset(player_pieces, opponent_pieces)
    player_positions = pieces_positions(player_pieces)
    opponent_positions = pieces_positions(opponent_pieces)
    return send("#{type}_moveset", player_positions, opponent_positions) if %i[knight pawn].any?(type)

    moveset = []
    %i[right_up right right_down down left_down left left_up up].each do |m|
      next unless moves.any?(m)

      method_moveset(player_positions, opponent_positions, moveset, m)
    end
    type == :king ? moveset + castle_moveset(player_pieces, opponent_pieces) : moveset
  end

  def black_piece?
    @color == :black
  end

  def moved?
    @moved
  end

  private

  def moves(type = self.type)
    case type
    when :rook then %i[right down left up]
    when :bishop then %i[right_up right_down left_down left_up]
    when :queen then %i[right_up right right_down down left_down left left_up up]
    when :king then moves(:queen)
    else []
    end
  end

  def method_moveset(player_positions, opponent_positions, moveset, method)
    send(method, type == :king ? 1 : 8).each do |pos|
      player_positions.any?(pos) ? break : moveset << pos
      break if opponent_positions.any?(pos)
    end
  end

  def knight_moveset(player_positions, _)
    vec = to_vector(position)
    m = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    m.map! do |move|
      pos_vec = [move[0] + vec[0], move[1] + vec[1]]
      coordinate = pos_vec.any?(&:negative?) ? nil : to_coordinate(pos_vec)
      player_positions.any?(coordinate) ? nil : coordinate
    end.compact
  end

  def pawn_moveset(player_positions, opponent_positions)
    moveset = pawn_up_moves(player_positions, opponent_positions)
    diagonal = black_piece? ? left_down(1) + right_down(1) : left_up(1) + right_up(1)
    diagonal.each { |pos| moveset << pos if opponent_positions.any?(pos) }
    moveset
  end

  def pawn_up_moves(player_positions, opponent_positions)
    up = case black_piece?
         when true then down(moved? ? 1 : 2)
         else up(moved? ? 1 : 2)
         end
    piece_positions = player_positions + opponent_positions
    up.clear if piece_positions.any?(up.first)
    up.pop if piece_positions.any?(up.last)
    up
  end

  def to_coordinate(vec)
    valid_vector?(vec) ? "#{('A'..'H').to_a[vec[1]]}#{vec[0] + 1}" : nil
  end

  def to_vector(cor)
    valid_coordinate?(cor) ? [cor[1].to_i - 1, cor[0].downcase.ord - 97] : nil
  end

  def valid_coordinate?(coordinate)
    coordinate.to_s[/^[a-hA-H][1-8]$/] != nil
  end

  def valid_vector?(vector)
    vector.is_a?(Array) && vector.length == 2 &&
      vector.all? { |i| i.to_s[/[0-7]/] }
  end

  def pieces_positions(pieces)
    pieces.map(&:position)
  end
end
