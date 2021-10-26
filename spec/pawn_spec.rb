# frozen-string-literal: true

require_relative '../lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new(unicode_pawn) }
  let(:unicode_pawn) { '🨾' }
end
