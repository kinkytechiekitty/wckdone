require 'redis'
require 'connection_pool'

REDIS = ConnectionPool.new(size: 10) { Redis.new }
