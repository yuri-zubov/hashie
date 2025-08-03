# frozen_string_literal: true
require 'spec_helper'

describe Hashie::Extensions::IgnoreUndeclared do
  context 'included in Trash' do
    class ForgivingTrash < Hashie::Trash
      include Hashie::Extensions::IgnoreUndeclared
      property :city
      property :state, from: :province
      property :str_state, from: 'str_provence'
    end

    subject { ForgivingTrash }

    it 'silently ignores undeclared properties on initialization' do
      expect { subject.new(city: 'Toronto', province: 'ON', country: 'Canada') }.to_not raise_error
    end

    it 'works with translated properties (with symbol keys)' do
      expect(subject.new(province: 'Ontario').state).to eq('Ontario')
    end

    it 'works with translated properties (with string keys)' do
      expect(subject.new('str_provence' => 'Ontario').str_state).to eq('Ontario')
    end

    it 'requires properties to be declared on assignment' do
      hash = subject.new(city: 'Toronto')
      expect { hash.country = 'Canada' }.to raise_error(NoMethodError)
    end

    context 'with a default value' do
      let(:test) do
        Class.new(Hashie::Trash) do
          include Hashie::Extensions::IgnoreUndeclared

          property :description, from: :desc, default: ''
        end
      end

      include_examples 'Dash default handling', :description, :desc
    end
  end

  context 'combined with DeepMerge' do
    class ForgivingTrashWithMerge < Hashie::Trash
      include Hashie::Extensions::DeepMerge
      include Hashie::Extensions::IgnoreUndeclared
      property :some_key
    end

    it 'deep merges' do
      class ForgivingTrashWithMergeAndProperty < ForgivingTrashWithMerge
        property :some_other_key
      end
      hash = ForgivingTrashWithMergeAndProperty.new(some_ignored_key: 17, some_key: 12)
      expect(hash.deep_merge(some_other_key: 55, some_ignored_key: 18))
        .to eq(some_key: 12, some_other_key: 55)
    end
  end
end
