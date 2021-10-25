# frozen-string-literal: true

require_relative '../lib/king'

describe King do
  subject(:king) { described_class.new(unicode_king) }
  let(:unicode_king) { '🨀' }
end
