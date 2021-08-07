module Filter
  class ArelVisitor
    def self.for_model(model)
      new(model.arel_table, model.attribute_types.with_indifferent_access)
    end

    def initialize(arel_table, serializers)
      self.collector   = arel_table
      self.serializers = serializers
    end

    def visit(node, collector = self.collector)
      self.collector = send("visit_#{node.class.name.demodulize}", node, collector)
    end

    def result
      collector.to_sql
    end

    private

    attr_accessor :collector, :serializers

    def visit_FieldNode(node, collector)
      collector[node.field]
    end

    def visit_LiteralNode(node, _collector)
      Arel.sql(node.literal)
    end

    def visit_GreaterThanNode(node, collector)
      collector[node.field].gt(serializers[node.field].serialize(node.value))
    end

    def visit_GreaterThanEqualNode(node, collector)
      collector[node.field].gteq(serializers[node.field].serialize(node.value))
    end

    def visit_LessThanNode(node, collector)
      collector[node.field].lt(serializers[node.field].serialize(node.value))
    end

    def visit_LessThanEqualNode(node, collector)
      collector[node.field].lteq(serializers[node.field].serialize(node.value))
    end

    def visit_EqualNode(node, collector)
      collector[node.field].eq(serializers[node.field].serialize(node.value))
    end

    def visit_NotEqualNode(node, collector)
      collector[node.field].not_eq(serializers[node.field].serialize(node.value))
    end

    def visit_FullTextScanNode(node, collector)
      collector[node.field].text_scan(node.value)
    end

    def visit_InNode(node, collector)
      collector[node.field].in(node.value.map { |it| serializers[node.field].serialize(it) })
    end

    def visit_ArrayContainsNode(node, collector)
      sanitized_operand = node.value.map do |it|
        sanitized = ActiveRecord::Base.sanitize_sql_like(serializers[node.field].serialize(it))
        %W(#{sanitized} #{sanitized},% %,#{sanitized} %,#{sanitized},%)
      end

      collector[node.field].matches_any(sanitized_operand.flatten)
    end

    def visit_StringContainsNode(node, collector)
      collector[node.field].matches(ActiveRecord::Base.sanitize_sql_like(node.value))
    end

    def visit_AndNode(node, collector)
      visit(node.left, collector).and(visit(node.right, collector))
    end

    def visit_OrNode(node, collector)
      visit(node.left, collector).or(visit(node.right, collector))
    end

    def visit_GroupedNode(node, collector)
      collector.grouping(visit(node.node, collector))
    end
  end
end
