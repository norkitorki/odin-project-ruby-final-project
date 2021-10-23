# frozen-string-literal: true

require_relative '../lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new(unicode_bishop) }
  let(:unicode_bishop) { '🨃' }
end
