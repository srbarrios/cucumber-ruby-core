require 'cucumber/initializer'
require 'cucumber/core/test/result'
require 'cucumber/core/test/mapping'

module Cucumber
  module Core
    module Test
      class Step
        include Cucumber.initializer(:source)

        def initialize(source, mapping = Test::UndefinedMapping.new)
          raise ArgumentError if source.any?(&:nil?)
          @mapping = mapping
          super(source)
        end

        def describe_to(visitor, *args)
          visitor.test_step(self, *args)
        end

        def describe_source_to(visitor, *args)
          source.each do |node|
            node.describe_to(visitor, *args)
          end
        end

        def name
          step.name
        end

        def multiline_arg
          step.multiline_arg
        end

        def skip
          @mapping.skip
        end

        def execute
          @mapping.execute
        end

        def define(&block)
          self.class.new(source, Test::Mapping.new(&block))
        end

        def inspect
          "#{name}: #{@mapping.class}"
        end

        private

        def step
          source.last
        end

      end
    end
  end
end
