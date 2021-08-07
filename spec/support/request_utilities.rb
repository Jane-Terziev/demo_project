module RequestUtilities
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body)
    end

    def check_json_response(json, keys)
      json_keys = json.is_a?(Array) ? json.first.keys : json.keys
      expect(json_keys).to contain_exactly(*keys)
    end

    def check_correct_filtering(json, correct_items)
      expect(json.count).to eq(correct_items.count)
      ids = correct_items.pluck(:id)
      json.each do |json_item|
        expect(ids.include?(json_item['id'])).to eq(true)
      end
    end
  end
end
