module Filter
  AbstractToken = Struct.new(:value) do
    def type
      self.class
    end
  end

  class NilToken < AbstractToken
    def initialize
      self.value = nil
    end
  end

  EndGroupToken = Class.new(AbstractToken)

  class FilterToken < AbstractToken
    attr_reader :field, :operators

    def initialize(field, operators)
      self.field = field
      self.operators = operators
    end

    private

    attr_writer :field, :operators
  end

  GreaterThanOrEqualToken = Class.new(AbstractToken)
  GreaterThanToken        = Class.new(AbstractToken)
  LessThanToken           = Class.new(AbstractToken)
  LessThanEqualToken      = Class.new(AbstractToken)
  EqualToken              = Class.new(AbstractToken)
  InToken                 = Class.new(AbstractToken)
  StringContainsToken     = Class.new(AbstractToken)
  ArrayContainsToken      = Class.new(AbstractToken)
  NotEqualsToken          = Class.new(AbstractToken)
  ScanToken               = Class.new(AbstractToken)

  class ConnectiveToken < AbstractToken
    attr_reader :symbol

    def initialize(symbol)
      self.symbol = symbol
    end

    private

    attr_writer :symbol
  end

  AndToken                = Class.new(ConnectiveToken)
  OrToken                 = Class.new(ConnectiveToken)
end
