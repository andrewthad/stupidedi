module Stupidedi
  module Reader

    class SimpleElementTok
      include Inspect

      # @return [String, Object]
      attr_reader :value

      # @return [Position]
      attr_reader :position

      # @return [Position]
      attr_reader :remainder

      def initialize(value, position, remainder)
        @value, @position, @remainder =
          value, position, remainder
      end

      def pretty_print(q)
        q.pp(:simple.cons(@value.cons))
      end

      def repeated
        RepeatedElementTok.new(self.cons, @position)
      end

      def repeated?
        false
      end

      def blankness?
        @value.blankness?
      end

      def is_present?
        not blankness?
      end

      def simple?
        true
      end

      def composite?
        false
      end
    end

    class << SimpleElementTok
      # @group Constructors
      #########################################################################

      def build(value, position, remainder)
        new(value, position, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
