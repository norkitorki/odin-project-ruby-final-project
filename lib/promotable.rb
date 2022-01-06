# frozen-string-literal: true

# pawn promotion handling
module Promotable
  PROMOTABLE_TYPES = %w[rook knight bishop queen].freeze

  def promotable?
    return false unless type == :pawn && position

    %w[1 8].any?(rank)
  end

  def promote(player, symbols)
    puts promotion_message
    type_input = gets.chomp.downcase until PROMOTABLE_TYPES.any?(type_input)
    type = type_input.to_sym
    new_piece = self.class.new(type, position, symbols[type], color: color)
    player.add_piece(new_piece)
    player.remove_piece(position)
  end

  def promotion_message
    <<~MESSAGE
      Pawn at #{position} has been promoted!

      Please input a new piece to replace it with: [ \e[0;32;49m#{PROMOTABLE_TYPES.join(', ')}\e[0m ]
    MESSAGE
  end
end
