require 'util/persistence/aggregate_root'

class Post < AggregateRoot
  MIN_TITLE_LENGTH = 5
  MAX_TITLE_LENGTH = 15
  MAX_BODY_LENGTH = 1000

  has_many :comments, class_name: Comment.name, autosave: true, dependent: :delete_all

  def self.create_new(title:, body:)
    post = new(title: title, body: body)
    post.apply_event(
        CreatedEvent.new(
            data: {
                title: post.title,
                body: post.body
            }
        )
    )
    post
  end

  def update_post(title:, body:)
    raise ArchivedError.new('Cannot update archived post.') if archived

    assign_attributes(title: title, body: body)
    apply_event(
        UpdatedEvent.new(
            data: {
                id: id,
                title: title,
                body: body
            }
        )
    )
  end

  def archive
    return if self.archived
    self.archived = true
    apply_event(
        ArchivedEvent.new(
            data: {
                id: id,
                title: title
            }
        )
    )
  end

  def add_comment(title:, body:)
    raise ArchivedError.new('Cannot comment on archived post.') if self.archived

    comments << Comment.create_new(title: title, body: body)

    apply_event(
        Comment::CreatedEvent.new(
            data: {
                post_id: id,
                post_title: self.title,
                comment_title: title,
                comment_body: body
            }
        )
    )
  end
end