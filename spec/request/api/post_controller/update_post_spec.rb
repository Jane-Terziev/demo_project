require 'swagger_helper'

RSpec.describe 'Updates a Post', swagger_doc: 'v1/swagger_common.yaml', type: :request do
  path '/api/posts/{id}' do
    put 'Updates a Post' do
      tags 'Posts'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :params, in: :body, required: true,  schema: {
          type: :object, properties: {
              post: {
                  type: :object, properties: {
                      title: { type: :string, description: 'Minimum size 5, Maximum size 15' },
                      body: { type: :string, description: 'Maximum size 1000' }
                  }
              }
          }
      }

      response '200', 'Post Updated' do
        let(:id) { create(:post).id }
        let(:params) do
          {
              post: {
                  title: 'random title',
                  body: 'body'
              }
          }
        end

        run_test!
      end

      response '404', 'Record Not Found' do
        schema '$ref' => '#/definitions/record_not_found_error'

        let(:id) { 1 }
        let(:params) do
          {
              post: {
                  title: 'random title',
                  body: 'body'
              }
          }
        end

        run_test!
      end

      response '422', 'Invalid parameters' do
        schema '$ref' => '#/definitions/constraint_violation_error'

        let(:id) { 1 }
        let(:params) do
          {
              post: {
                  title: 'a' * 16,
                  body: 'body'
              }
          }
        end

        run_test!
      end
    end
  end
end