FactoryBot.define do
  factory :post, class: Post.name do
    sequence(:id) { |n| n.to_i }
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    archived { false }
  end
end
