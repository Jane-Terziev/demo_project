module Versionable
  def api_version(version:, options: {}, default: false, &block)
    namespace(version, options, &block)
    setup_default_version_routes(version, options, &block) if default
  end

  def setup_default_version_routes(version, options, &block)
    route_config = { module: version, as: 'default' }
    scope(route_config.merge(options), &block)
  end
end
