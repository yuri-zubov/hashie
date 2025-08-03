# frozen_string_literal: true
module Hashie
  module Extensions
    module PrettyInspect
      def self.included(base)
        base.send :alias_method, :hash_inspect, :inspect
        base.send :alias_method, :inspect, :hashie_inspect
      end

      def hashie_inspect
        "#<#{self.class}" \
          "#{keys.sort_by(&:to_s).map { |k| " #{k}=#{self[k].inspect}" }.join}" \
          ">"
      end
    end
  end
end
