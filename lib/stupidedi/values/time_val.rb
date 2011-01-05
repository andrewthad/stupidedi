module Stupidedi
  module Values

    class TimeVal < SimpleElementVal

      class Empty < TimeVal
        def empty?
          true
        end

        def present?
          false
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "TimeVal.empty#{def_id}"
        end

        def ==(other)
          other.is_a?(self.class)
        end
      end

      class NonEmpty < TimeVal
        attr_reader :hour, :minute, :second

        def initialize(hour, minute, second, element_def)
          @hour, @minute, @second = hour, minute, second
          super(element_def)
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "TimeVal.value#{def_id}(#{hour}:#{minute}:#{second})"
        end

        def empty?
          false
        end

        def present?
          true
        end

        def to_time(date)
          # TODO
          raise NoMethodError, "Not yet implemented"
        end

        def to_datetime(date)
          # TODO
          raise NoMethodError, "Not yet implemented"
        end

        def ==(other)
          other.hour == hour and other.minute == minute and other.second == second
        end
      end

    end

    # Constructors
    class << TimeVal
      def empty(element_def = nil)
        TimeVal::Empty.new(element_def)
      end

      # Convert data read from ElementReader
      def value(hour, minute, second, element_def)
        # NOTE: string !~ /\S/ returns false if string contains any non-blank chars

        unless hour.to_s !~ /\S/ or hour.to_i.between?(0, 24)
          raise ArgumentError, "Hour must be between 0 and 24, got #{hour}"
        end

        unless minute.to_s !~ /\S/ or minute.to_i.between?(0, 60)
          raise ArgumentError, "Minute must be between 0 and 60, got #{minute}"
        end

        unless second.to_s !~ /\S/
          unless second.slice(0, 2).to_i.between?(0, 60)
            raise ArgumentError, "Second must be between 0 and 60, got #{second}"
          end

          unless second.slice(0, 2) != '60' or second.slice(2..-1) =~ /^0*$/
            raise ArgumentError, "Second must be between 0 and 60, got #{second}"
          end
        end

        # Convert blank strings to nil with (x =~ /\S/ and x)
        TimeVal::NonEmpty.new(hour, (minute.to_s =~ /\S/ and minute), (second.to_s =~ /\S/ and second), element_def)
      end

      # Convert a ruby Time value
      def from_time(time)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end

      # Convert a ruby DateTime value
      def from_datetime(datetime)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end
    end

    # Prevent direct instantiation of abstract class String
    TimeVal.eigenclass.send(:protected, :new)
    TimeVal::Empty.eigenclass.send(:public, :new)
    TimeVal::NonEmpty.eigenclass.send(:public, :new)

  end
end