class RedisService
  def initialize
    @redis = Rails.cache.redis
  end

  def set_hash(key, field, value, expires_in: nil)
    @redis.with do |conn|
      conn.hset(key, field, value)
      conn.expire(key, expires_in) if expires_in
    end
  end

  def get_hash(key, field)
    @redis.with do |conn|
      conn.hget(key, field)
    end
  end

end
