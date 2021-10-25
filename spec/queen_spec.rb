# frozen-string-literal: true

require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(unicode_queen) }
  let(:unicode_queen) { '🨁' }
end
