class HtmlSanitizer
  def self.sanitize(string)
    Rack::Utils.escape_html(string).gsub(/(\n)|(\r)/, '<br />').html_safe
  end
end
