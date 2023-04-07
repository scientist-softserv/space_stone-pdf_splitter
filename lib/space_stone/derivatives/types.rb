# frozen_string_literal: true

require 'space_stone/derivatives/type'


module SpaceStone
  module Derivatives
    ##
    # @api public
    #
    # A coercing function, similart to Array().
    #
    # @param type [#to_sym]
    #
    # @return [SpaceStone::Derivatives::BaseType]
    # @raise [NameError] when given type is not registered.
    def self.Type(symbol)
      demodulized_klass = "#{symbol.to_sym}_type".classify
      "SpaceStone::Derivatives::Type::#{demodulized_klass}".constantize
    end

    ##
    # The module space for declaring named derivative type (e.g. `:image`, `:monochrome`, etc.).  A
    # named derivative type should be able to generate itself based on the given {Environment}.
    #
    # @see BaseType
    # @see BaseType.generate_for
    module Type
      ##
      # @abstract
      # @see Type
      # @see Types
      class BaseType
        class_attribute :prerequisites, default: []
        class_attribute :spawns, default: []

        ##
        # @api public
        #
        # @param environment [SpaceStone::Derivatives::Environment]
        #
        # @see #generate
        def self.generate_for(environment:)
          new(environment: environment).generate
        end

        ##
        # @api public
        #
        # @return [Symbol]
        def self.to_sym
          to_s.demodulize.underscore.sub("_type", "").to_sym
        end

        ##
        # @api public
        # @return [Symbol]
        def to_sym
          self.class.to_sym
        end

        def initialize(environment:)
          @environment = environment
        end
        attr_reader :environment

        def generate
          raise NotImplementedError
        end
      end
    end


    module Types
      def self.for(type)
        raise
        Type(type)
      end
    end
  end
end
