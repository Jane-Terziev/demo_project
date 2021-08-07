require 'swagger_helper'

RSpec.describe 'Show Post', swagger_doc: 'v1/swagger_common.yaml', type: :request do
  path '/api/posts/{id}' do
    get 'Show post details' do
      tags 'Posts'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]

      parameter name: :id, in: :path, type: :string, required: true

      response '200', 'Show Post Details' do
        schema 'ref' => '#/definitions/post_details'
        let!(:post) { create(:post) }
        let(:id) { post.id }

        context "when post has no comments" do
          it 'should return post details' do |example|
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)

            expect(json_response["comments"].length).to eq(0)
          end
        end

        context "when post has comments" do
          it 'should return post details with no comments if archived' do |example|
            create_list(:comment, 2, post: post, archived: true)

            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)

            expect(json_response["comments"].length).to eq(0)
          end

          it 'should return post details with comments if not archived' do |example|
            create_list(:comment, 2, post: post, archived: false)

            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)

            expect(json_response["comments"].length).to eq(2)
          end
        end
      end

      response '404', 'Record Not Found' do
        schema '$ref' => '#/definitions/record_not_found_error'

        let(:id) { 1 }

        run_test!
      end
    end
  end
end