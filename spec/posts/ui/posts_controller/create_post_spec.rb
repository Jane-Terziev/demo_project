require 'swagger_helper'

RSpec.describe 'Creating a Post', swagger_doc: 'v1/swagger_common.yaml', type: :request do
  path '/api/posts' do
    post 'Creates a Post' do
      tags 'Posts'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]

      parameter name: :params, in: :body, schema: {
          type: :object, properties: {
              post: {
                  type: :object, properties: {
                      title: { type: :string, description: 'Minimum size 5, Maximum size 15' },
                      body: { type: :string, description: 'Maximum size 1000' }
                  }
              }
          }
      }

      response '201', 'Post Created' do
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