RSpec.describe PostService, type: :unit do
  subject(:service) do
    described_class.new(
        post_repository: post_repository,
        event_publisher: event_publisher
    )
  end
  
  let(:post_repository) { class_double('Post') }
  let(:event_publisher) { instance_double('MetadataEventPublisher').as_null_object }

  describe "#.create_post(command)" do
    let(:command) { ::Post::CreateCommand.new(title: 'title', body: 'body') }

    context "when called with valid parameters" do
      let(:post) { build(:post) }

      before do
        allow(post_repository).to receive(:create_new).and_return(post)
        allow(post_repository).to receive(:save!)
        allow(event_publisher).to receive(:publish_all)
      end

      it 'should create a new post and publish event' do
        service.create_post(command)
        
        expect(post_repository).to have_received(:create_new).with({ title: command.title, body: command.body })
        expect(post_repository).to have_received(:save!).with(post)
        expect(event_publisher).to have_received(:publish_all).once
      end
    end
  end

  describe "#.update_post(command)" do
    let(:command) { ::Post::UpdateCommand.new(id: 1, title: 'title', body: 'body') }

    context "when post is not found" do
      before do
        allow(post_repository).to receive(:find_by_id).and_return(Optional.empty)
        allow(post_repository).to receive(:save!)
        allow(event_publisher).to receive(:publish_all)
      end

      it 'should raise ApiError::RecordNotFound error' do
        expect { service.update_post(command) }.to raise_error(ApiError::RecordNotFound)
        expect(post_repository).to have_received(:find_by_id)
        expect(post_repository).to_not have_received(:save!)
        expect(event_publisher).to_not have_received(:publish_all)
      end
    end

    context "when post is found" do
      let(:post) { build(:post) }

      before do
        allow(post_repository).to receive(:find_by_id).and_return(Optional.of_nullable(post))
        allow(post_repository).to receive(:save!)
        allow(event_publisher).to receive(:publish_all)
      end

      it 'should update post and publish events' do
        expect { service.update_post(command) }.to_not raise_error
        expect(post_repository).to have_received(:find_by_id).with(command.id)
        expect(post_repository).to have_received(:save!).with(post)
        expect(event_publisher).to have_received(:publish_all).with(post.domain_events)
      end
    end
  end

  describe "#.archive_post(command)" do
    context "when post is not found" do
      before do
        allow(post_repository).to receive(:find_by_id).and_return(Optional.empty)
        allow(post_repository).to receive(:save!)
        allow(event_publisher).to receive(:publish_all)
      end

      it 'should raise ApiError::RecordNotFound' do
        expect { service.archive_post(1) }.to raise_error(ApiError::RecordNotFound)
        expect(post_repository).to have_received(:find_by_id)
        expect(post_repository).to_not have_received(:save!)
        expect(event_publisher).to_not have_received(:publish_all)
      end
    end

    context "when post is found" do
      let(:post) { build(:post) }

      before do
        allow(post_repository).to receive(:find_by_id).and_return(Optional.of_nullable(post))
        allow(post_repository).to receive(:save!)
        allow(event_publisher).to receive(:publish_all)
      end

      it 'should raise ApiError::RecordNotFound' do
        expect { service.archive_post(1) }.to_not raise_error
        expect(post_repository).to have_received(:find_by_id)
        expect(post_repository).to have_received(:save!)
        expect(event_publisher).to have_received(:publish_all)
      end
    end
  end
end
