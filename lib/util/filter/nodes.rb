module Filter
  AbstractNode = Class.new

  class BinaryNode < AbstractNode
    attr_reader :left, :right

    def initialize(left, right)
      self.left = left
      self.right = right
    end

    private

    attr_writer :left, :right
  end

  AndNode = Class.new(BinaryNode)
  OrNode  = Class.new(BinaryNode)

  class FieldNode < AbstractNode
    attr_reader :field

    def initialize(field)
      self.field = field
    end

    private

    attr_writer :field
  end

  class LiteralNode < AbstractNode
    attr_reader :literal

    def initialize(literal)
      self.literal = literal
    end

    private

    attr_writer :literal
  end

  class FilterNode < AbstractNode
    attr_reader :field, :value

    def initialize(field, value)
      self.field = field
      self.value = value
    end

    private

    attr_writer :field, :value
  end

  class ArrayValueFilterNode < FilterNode
    def initialize(field, value)
      super(field, value.respond_to?(:split) ? value.split(',') : value)
    end
  end

  EqualNode        = Class.new(FilterNode)
  FullTextScanNode = Class.new(FilterNode)
  GreaterThanNode  = Class.new(FilterNode)
  GreaterThanEqualNode = Class.new(FilterNode)
  InNode               = Class.new(ArrayValueFilterNode)
  LessThanEqualNode    = Class.new(FilterNode)
  LessThanNode         = Class.new(FilterNode)
  NotEqualNode         = Class.new(FilterNode)
  StringContainsNode   = Class.new(FilterNode)
  ArrayContainsNode    = Class.new(ArrayValueFilterNode)

  class GroupedNode < AbstractNode
    attr_reader :node

    def initialize(node)
      self.node = node
    end

    private

    attr_writer :node
  end
end
