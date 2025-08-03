# frozen_string_literal: true

require 'rspec'

RSpec.describe Hashie::Extensions::Array::PrettyInspect do
  class PrettyArray < Array
    include Hashie::Extensions::Array::PrettyInspect
  end

  it 'raises FrozenError when using frozen string literal' do
    array = PrettyArray.new([:a, :b])
    expect { array.inspect }.to raise_error(FrozenError)
  end
end
