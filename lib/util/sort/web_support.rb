require_relative 'sort'
require_relative 'sort_formatter'
require 'util/optional'

module Sort
  module WebSupport
    Sort = Types.Constructor(::Sort::Sort) do |values|
      Optional
        .of_nullable(values)
        .flat_map { |it| Optional.of_nullable(it[:sort]) }
        .map      { |it| ::Sort::SortFormatter.from_query_string(it) }
        .or_else_get { ::Sort::Sort.empty }
    end
  end
end
