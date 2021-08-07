module Api
  module V1
    class PostsController < ApiController
      include DemoProject::Import[
                  post_service: 'post_service',
                  post_read_service: 'read_model.post_service'
              ]

      def index
        render json: post_read_service.filter_posts(
            ::Post::FilterPostQuery.new(
                filter: filter,
                sort: sort,
                page_request: page_request
            )
        )
      end

      def show
        render json: post_read_service.get_post_by_id(::Post::GetPostByIdQuery.new(id: params[:id].to_i))
      end

      def create
        whitelisted_params = validator.validate(post_params, ::Post::CreateContract.new)
        post_service.create_post(::Post::CreateCommand.new(whitelisted_params))

        render_success(Http::STATUS_CREATED)
      end

      def update
        whitelisted_params = validator.validate(post_params, ::Post::UpdateContract.new)
        post_service.update_post(
            ::Post::UpdateCommand.new(
                whitelisted_params.merge(id: params[:id].to_i)
            )
        )
        render_success(Http::STATUS_OK)
      end

      def destroy
        post_service.archive_post(params[:id].to_i)

        head :no_content
      end

      def post_params
        params.require(:post).to_unsafe_h
      end
    end
  end
end