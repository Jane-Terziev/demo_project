module Arel
  module Nodes
    class FullTextMatch < Binary
      attr_accessor :opts

      def initialize(left, right, opts = nil)
        super(left, right)
        @opts = opts
      end
    end
  end
end
