require 'swagger_helper'

RSpec.describe 'Lists all Post', swagger_doc: 'v1/swagger_common.yaml', type: :request do
  path '/api/posts' do
    get 'List all posts' do
      tags 'Posts'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]

      parameter name: :page,         in: :query, type: :string, required: false
      parameter name: :page_size,    in: :query, type: :string, required: false
      parameter name: :filters,      in: :query, type: :string, required: false,
                description: <<~DESC
                  Filters to filter by. Filter syntax is as follows: filters[][<field_to_filter_by>[<operator>]]=<value>.
                  Currently, only the following operators are supported:
                    [
                      eq (equal), lt (less than), lte (less than or equal), gt (greater than), 
                      gte (greater than or equal), in (inclusion operator), matches (string partial match)
                    ].
                  This is supposed to simulate rich data structures sent as query parameters.
      DESC
      parameter name: :sort, in: :query, type: :string, required: false,
                description: <<~DESC
                  Specifies fields to sort by. Format is sort=(-)<field>,<some_other_field>. 
                  It is a comma-separated string of fields.
                  A `-` before the name of the field indicates that sorting should be done in descending order.
                  Otherwise, the sorting order is ascending.
                  Dot-separated fields are also supported, e.g table_name.field_name
                  There is no restriction on what values can be passed here, although if the field does not exist, 
                  a 400 Bad Request error will be returned.
                  Similarly, if the attribute is badly formed, e.g table_name..field_name, or if it contains special 
                  characters, a 400 Bad Request error will be returned.
      DESC


      response '200', 'List Posts' do
        schema 'ref' => '#/definitions/list_posts'
        let!(:post) { create(:post) }

        it 'should list all posts' do |example|
          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
          expect(response.parsed_body["items"].length).to eq(1)
          expect(response.parsed_body["items"][0]["number_of_comments"]).to eq(0)
        end

        it 'should have number of comments eq to 2' do |example|
          create_list(:comment, 2, post: post)

          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
          expect(response.parsed_body["items"].length).to eq(1)
          expect(response.parsed_body["items"][0]["number_of_comments"]).to eq(2)
        end
      end

      response '400', 'Invalid Query Parameter' do
        schema '$ref' => '#/definitions/record_not_found_error'
        let(:id) { create(:post).id }
        let(:page) { '1' }
        let(:page_size) { '10' }

        let(:params) do
          {
              page: page,
              page_size: page_size
          }
        end

        it 'should raise invalid query parameter error' do
          params[:filters] = [ invalid_field: { in: 1 } ]
          get api_default_posts_url, params: params

          expect(response.status).to eq(400)
        end
      end
    end
  end
end