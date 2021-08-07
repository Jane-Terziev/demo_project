require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#.create_new(title:, body:)" do
    context "when creating a new post" do
      it 'should assign all attributes' do
        title = 'title'
        body = 'body'
        post = Post.create_new(title: title, body: body)
        expect(post.title).to eq(title)
        expect(post.body).to eq(body)

        expect { Post.save!(post) }.to_not raise_error

        expect(post.archived).to eq(false)
        expect(post.domain_events).to contain_exactly(kind_of(Post::CreatedEvent))
      end
    end
  end

  describe "#.update_post(title:, body:)" do
    context "when updating an archived post" do
      it 'should raise PostArchivedError' do
        title = 'new title'
        body = 'new body'
        post = build(:post, archived: true)

        expect { post.update_post(title: title, body: body)}.to raise_error(Post::ArchivedError)
      end
    end

    context "when updating a post that is not archived" do
      it 'should update attributes' do
        new_title = 'new title'
        new_body = 'new body'
        post = build(:post, archived: false)

        expect { post.update_post(title: new_title, body: new_body)}.to_not raise_error

        expect(post.title).to eq(new_title)
        expect(post.body).to eq(new_body)
        expect(post.domain_events).to contain_exactly(kind_of(Post::UpdatedEvent))
      end
    end
  end

  describe "#.archive" do
    context "when post is not archived" do
      it 'should change archived to true' do
        post = build(:post, archived: false)
        post.archive

        expect(post.archived).to be_truthy
        expect(post.domain_events).to contain_exactly(kind_of(Post::ArchivedEvent))
      end
    end

    context "when post is already archived" do
      it 'should return and not register event' do
        post = build(:post, archived: true)
        post.archive

        expect(post.domain_events).to be_empty
      end
    end
  end

  describe '#.add_comment(title:, body:)' do
    context "when the post has been archived" do
      it 'should raise ArchivedError' do
        post = build(:post, archived: true)
        expect { post.add_comment(title: 'new title', body: 'new body') }.to raise_error(Post::ArchivedError)
      end
    end

    context "when the post is not archived" do
      it 'should raise ArchivedError' do
        post = build(:post, archived: false)
        title = 'title'
        body = 'body'
        expect { post.add_comment(title: title, body: body) }.to_not raise_error
        expect(post.comments.length).to eq(1)
        comment = post.comments[0]
        expect(comment.title).to eq(title)
        expect(comment.body).to eq(body)
        expect(post.domain_events).to contain_exactly(kind_of(Comment::CreatedEvent))
      end
    end
  end
end
