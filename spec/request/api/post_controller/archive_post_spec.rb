require 'swagger_helper'

RSpec.describe 'Archive a Post', swagger_doc: 'v1/swagger_common.yaml', type: :request do
  path '/api/posts/{id}' do
    delete 'Archives a Post' do
      tags 'Posts'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]

      parameter name: :id, in: :path, type: :string, required: true

      response '204', 'Post Archived' do
        let(:id) { create(:post).id }

        run_test!
      end

      response '404', 'Record Not Found' do
        schema '$ref' => '#/definitions/record_not_found_error'

        let(:id) { 1 }

        run_test!
      end
    end
  end
end