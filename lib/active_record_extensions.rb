module ActiveRecordExtensions
  def find_by(value, &block)
    to_a.map(&block).find { |it| it == value }
  end
end
