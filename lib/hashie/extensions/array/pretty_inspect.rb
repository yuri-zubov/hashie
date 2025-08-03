# frozen_string_literal: true
module Hashie
  module Extensions
    module Array
      module PrettyInspect
        def self.included(base)
          base.send :alias_method, :array_inspect, :inspect
          base.send :alias_method, :inspect, :hashie_inspect
        end

        def hashie_inspect
          "#<#{self.class} [" \
            "#{to_a.map(&:inspect).join(', ')}" \
            "]>"
        end
      end
    end
  end
end
