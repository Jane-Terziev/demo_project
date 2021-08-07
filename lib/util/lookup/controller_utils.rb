module ControllerUtils
  extend ActiveSupport::Concern

  included do
    include DemoProject::Import[lookup_service_factory: 'util.lookup.service_factory']

    def create
      result = resource_contract.call(resource_params.first.to_h)
      result.success? ? create_resource(result.to_h) : display_validation_errors(result.errors.to_h, 'new')
    end

    def destroy
      lookup_service_factory.new(lookup_table_repository: lookup_table_repository).destroy(params[:id])
      redirect_to collection_path
    end

    private

    def create_resource(params)
      @resource = lookup_service_factory
                    .new(lookup_table_repository: lookup_table_repository)
                    .create(params)
      redirect_to resource_path(@resource)
    end

    def display_validation_errors(errors, action)
      @resource = lookup_table_repository.new(resource_params.first)
      errors.each { |key, message| @resource.errors.add(key, message) }
      render action: action
    end
  end
end
