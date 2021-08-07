FactoryBot.define do
  factory :comment, class: Posts::Domain::Comment.name do
    sequence(:id) { |n| n.to_i }
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    archived { false }
    post
  end
end
