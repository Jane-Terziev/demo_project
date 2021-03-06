module Arel
  module Visitors
    class MySQL < ToSql
      private

      # TODO: refactor for explicit objects and type safety instead of raw string manipulation
      def visit_Arel_Nodes_FullTextMatch(o, collector)
        collector << 'MATCH ('
        collector = visit(o.left, collector)
        collector << ') AGAINST ('
        collector << quote(o.right)

        opts = ''
        unless o.opts.nil?
          if o.opts[:boolean_mode]
            opts = ' IN BOOLEAN MODE'
          elsif o.opts[:query_expansion]
            opts = ' WITH QUERY EXPANSION'
          end
        end

        collector << opts
        collector << ')'
        collector
      end
    end
  end
end
