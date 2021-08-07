module ReadModel
  class PostService < ApplicationReadService
    include DemoProject::Import[post_repository: 'read_model.post_repository']

    def filter_posts(query)
      map_with(
          page: post_repository.filter_posts(query.filter, query.page_request, query.sort),
          mapper: Mappers::ListPostMapper.new
      )
    rescue ActiveRecord::ActiveRecordError, Mysql2::Error => e
      raise ApiError::InvalidQuery, e.message
    end

    def get_post_by_id(query)
      map_into(
          source: post_repository.get_by_id(query.id),
          mapper: Mappers::PostDetailsMapper.new
      )
    end
  end
end