# config/initializers/redis_cache_check.rb

if Rails.env.development?
  begin
    # Test the Redis connection
    redis = ActiveSupport::Cache.lookup_store(:redis_cache_store)
    redis.stats


    Rails.logger.info "Redis cache connected and ready to use."
  rescue Exception => e
    Rails.logger.error "Redis cache connection failed: #{e.message}"
    raise "Redis cache connection failed: #{e.message}"
  end
end
